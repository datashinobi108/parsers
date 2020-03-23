require 'json'
require 'awesome_print'
require 'csv'

file_name_c = "cases.csv"
file_name_d = "deaths.csv"
meta_file = "countries.json"
header_file = "days.json"
csv_text_c = File.read(file_name_c)
csv_text_d = File.read(file_name_d)
countries = JSON.parse(File.read(meta_file))
countryCodes = countries.keys

days = JSON.parse(File.read(header_file))

deathMap = {}
countryCodes.each do |country|
  deathMap[country] = {}
  days.each do |day|
    deathMap[country][day] = ""
  end
end

startDate = DateTime.new(2020,1,21)

csv_d = CSV.parse(csv_text_d, :headers => true)
csv_d.each do |row|
  itemCode = row["Code"]
  val = row["Value"].to_f
  date = (startDate + row["Day"].to_i).strftime('%b %-d').to_s.strip

  if deathMap[itemCode] != nil
    deathMap[itemCode][date] = val.to_f
  end
end

headers = days.dup
headers.unshift("url")
headers.unshift("category")
headers.unshift("country")

caseMap = {}
countryCodes.each do |country|
  caseMap[country] = {}
  days.each do |day|
    caseMap[country][day] = ""
  end
end

csv_c = CSV.parse(csv_text_c, :headers => true)
csv_c.each do |row|
  itemCode = row["Code"]
  val = row["Value"].to_f
  date = (startDate + row["Day"].to_i).strftime('%b %-d').to_s.strip

  if caseMap[itemCode] != nil
    caseMap[itemCode][date] = val.to_f
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
        cases = caseMap[key][day]
        deaths = deathMap[key][day]
        if (deaths.to_i == 0 || cases.to_i <= 250)
          row[day] = ""
        else
          row[day] = cases.to_f / deaths.to_f
        end
      end
    end
  end
end
