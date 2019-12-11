require 'json'
require 'awesome_print'
require 'csv'

dynamicVarCountries = 50
dynamicVarShown = 20

years = JSON.parse(File.read("years.json"))
countries = JSON.parse(File.read("countries.json"))
countryCodes = countries.keys

megaMap = {}
years.each do |year|
  megaMap[year] = {}
  countryCodes.each do |country|
    megaMap[year][country] = nil
  end
end

File.open("data.csv").each do |line|
  cleanLine = line.strip

  arr = cleanLine.split(",")
  countryCode = arr[1]
  year = arr[2]
  val = arr[3].to_i

  if megaMap[year] != nil
    megaMap[year][countryCode] = val
  end
end

parsedMap = {}
countries.each do |key, values|
  count = 0
  years.each do |year|
    count = megaMap[year][key].to_i + count
  end
  parsedMap[key] = count
end

finalArr = parsedMap.sort_by {|k,v| v}.reverse[0..dynamicVarCountries-1].reverse

headers = (0..dynamicVarCountries).to_a
headers.unshift("url")
headers.unshift("country")
shownValues = (0..dynamicVarShown-1).to_a

CSV($stdout, headers: headers, write_headers: true) do |out|
  finalArr.each_with_index do |country, index|
    countryCode = country[0]
    countryValue = country[1]
    out << CSV::Row.new(headers, []).tap do |row|
      row["country"] = countries[countryCode]["label"]
      row["url"] = countries[countryCode]["url"]
      shownValues.each do |value|
        if (value + index < 50)
          row[value+index+2] = countryValue
        end
      end
      row[50+2] = countryValue
    end
  end
end
