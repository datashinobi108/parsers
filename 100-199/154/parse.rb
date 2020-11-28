require 'json'
require 'awesome_print'
require 'csv'

file_name = "data.csv"
meta_file = "regions.json"
header_file = "days.json"
csv_text = File.read(file_name)
regions = JSON.parse(File.read(meta_file))

days = JSON.parse(File.read(header_file))
headers = days.dup
headers.unshift("url")
headers.unshift("region")
regionCodes = regions.keys

megaMap = {}
regionCodes.each do |region|
  megaMap[region] = {}
  days.each do |day|
    megaMap[region][day] = ""
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

# ap regionCodes

CSV($stdout, headers: headers, write_headers: true) do |out|
  regions.each do |key, values|
    out << CSV::Row.new(headers, []).tap do |row|
      previousYear = nil
      days.each do |day|
        row["region"] = values["label"]
        row["url"] = values["url"]
        row[day] = megaMap[key][day]
      end
    end
  end
end
