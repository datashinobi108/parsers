require 'json'
require 'awesome_print'
require 'csv'

file_name = "./../../data/owid-covid-data.csv"
meta_file = "countries.json"
header_file = "days.json"
csv_text = File.read(file_name)
countries = JSON.parse(File.read(meta_file))

# categories = ['Asia & the Pacific', 'Europe', 'Africa', 'Latin America & the Caribbean', 'Oceania', 'North America']
categories = ['Europe']

header_country_code="iso_code"
header_country="country"
header_value="total_cases"
header_date="date"
header_url="url"
header_category="category"

days = JSON.parse(File.read(header_file))
headers = days.dup
headers.unshift(header_url)
headers.unshift(header_category)
headers.unshift(header_country)

selectedCountries = countries.select { |code, country| categories.include? country['category'] }

megaMap = {}
selectedCountries.keys.each do |country|
  megaMap[country] = {}
  days.each do |day|
    megaMap[country][day] = ""
  end
end

csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  itemCode = row[header_country_code]
  val = row[header_value].to_f
  date = Date.parse(row[header_date]).strftime('%b %d').to_s.strip

  if megaMap[itemCode] != nil
    megaMap[itemCode][date] = val
  end
end

# ap countryCodes

CSV($stdout, headers: headers, write_headers: true) do |out|
  selectedCountries.each do |key, values|
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
