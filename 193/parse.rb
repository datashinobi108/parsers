require 'json'
require 'awesome_print'
require 'csv'

file_name = "data.csv"
meta_file = "countries.json"
header_file = "years.json"
csv_text = File.read(file_name)
countries = JSON.parse(File.read(meta_file))

header_country_code="Code"
header_value="Value"
header_date="Year"

header_country="country"
header_url="url"
header_category="category"

days = JSON.parse(File.read(header_file))
headers = days.dup
headers.unshift(header_url)
headers.unshift(header_category)
headers.unshift(header_country)
countryCodes = countries.keys

megaMap = {}
countryCodes.each do |country|
  megaMap[country] = {}
  days.each do |day|
    megaMap[country][day] = ""
  end
end

csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  itemCode = row[header_country_code]
  val = row[header_value].to_f
  date = row[header_date]

  if megaMap[itemCode] != nil
    megaMap[itemCode][date] = val
  end
end

CSV($stdout, headers: headers, write_headers: true) do |out|
  countries.each do |key, values|
    out << CSV::Row.new(headers, []).tap do |row|
      previousYear = nil
      days.each do |day|
        row[header_country] = values["label"]
        row[header_url] = values["url"]
        row[header_category] = values["category"]
        row[day] = megaMap[key][day]
      end
    end
  end
end
