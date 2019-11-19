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
    megaMap[year][country] = ""
  end
end

# ap megaMap
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

CSV($stdout, headers: headers, write_headers: true) do |out|
  countries.each do |key, values|
    out << CSV::Row.new(headers, []).tap do |row|
      previousYear = 0
      years.each do |year|
        row["country"] = values["label"]
        row["url"] = values["url"]
        row[year] = megaMap[year][key].to_i + previousYear
        previousYear = row[year]
      end
    end
  end
end