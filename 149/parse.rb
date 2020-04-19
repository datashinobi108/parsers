require 'json'
require 'awesome_print'
require 'csv'

file_name = "data.csv"
meta_file = "countries.json"
header_file = "days.json"
csv_text = File.read(file_name)
countries = JSON.parse(File.read(meta_file))

days = JSON.parse(File.read(header_file))
headers = days.dup
headers.unshift("url")
headers.unshift("category")
headers.unshift("country")
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
  itemCode = row["Code"]
  val = row["Value"].to_f
  date = Date.parse(row["Date"]).strftime('%b %d').to_s.strip

  if megaMap[itemCode] != nil
    megaMap[itemCode][date] = val
  end
end

# ap countryCodes

CSV($stdout, headers: headers, write_headers: true) do |out|
  countries.each do |key, values|
    out << CSV::Row.new(headers, []).tap do |row|
      previousYear = nil
      days.each do |day|
        row["country"] = values["label"]
        row["url"] = values["url"]
        row["category"] = values["category"]
        row[day] = megaMap[key][day]
      end
    end
  end
end
