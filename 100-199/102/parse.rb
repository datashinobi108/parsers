require 'json'
require 'awesome_print'
require 'csv'

years = JSON.parse(File.read("years.json"))
headers = years.dup
headers.unshift("url")
headers.unshift("country")
countries = JSON.parse(File.read("countries.json"))
countryCodes = countries.keys

megaMap = {}
years.each do |year|
  megaMap[year] = {}
  countryCodes.each do |country|
    megaMap[year][country] = 0
  end
end

# ap megaMap

File.open("cumulative-co-emissions.csv").each do |line|
  cleanLine = line.strip

  arr = cleanLine.split(",")
  countryCode = arr[1]
  year = arr[2]
  emission = arr[3].to_f
  emission = emission/1000000.0

  if megaMap[year] != nil
    megaMap[year][countryCode] = emission
  end
end

CSV($stdout, headers: headers, write_headers: true) do |out|
  countries.each do |key, values|
    out << CSV::Row.new(headers, []).tap do |row|
      years.each do |year|
        row["country"] = values["label"]
        row["url"] = values["url"]
        row[year] = megaMap[year][key]
      end
    end
  end
end