require 'json'
require 'awesome_print'
require 'csv'

years = JSON.parse(File.read("years.json"))
headers = years.dup
headers.unshift("category")
headers.unshift("url")
headers.unshift("country")
countries = JSON.parse(File.read("countries.json"))
countryCodes = countries.keys

megaMap = {}
countryCodes.each do |country|
  megaMap[country] = {}
  years.each do |year|
    megaMap[country][year] = ""
  end
end

# ap megaMap
File.open("data.csv").each do |line|
  cleanLine = line.strip

  arr = cleanLine.split(",")
  countryCode = arr[1]
  year = arr[2]
  val = arr[3]

  if megaMap[countryCode] != nil
    megaMap[countryCode][year] = val.to_f * 1000
  end
end

CSV($stdout, headers: headers, write_headers: true) do |out|
  countries.each do |key, values|
    out << CSV::Row.new(headers, []).tap do |row|
      previousYear = nil
      years.each do |year|
        row["country"] = values["label"]
        row["url"] = values["url"]
        row["category"] = values["category"]
        # row[year] = megaMap[key][year]
        value = megaMap[key][year]
        if value == "" && previousYear != nil
          row[year] = previousYear
        else
          row[year] = megaMap[key][year].to_i
          previousYear = row[year]
        end
      end
    end
  end
end