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

numbers = []
yearInQuestion = 2016

File.open("data.csv").each do |line|
  cleanLine = line.strip

  arr = cleanLine.split(",")
  countryCode = arr[1]
  year = arr[2].to_i
  val = arr[3].to_i

  if (year == yearInQuestion)
    numbers.push(val)
  end
end

ap numbers.sort.reverse[0..19]

CSV($stdout, headers: headers, write_headers: true) do |out|
  countries.each do |key, values|
    out << CSV::Row.new(headers, []).tap do |row|
      previousYear = nil
      years.each do |year|
        row["country"] = values["label"]
        row["url"] = values["url"]
        row["category"] = values["category"]
      end
    end
  end
end
