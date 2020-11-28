require 'json'
require 'awesome_print'
require 'csv'

years = JSON.parse(File.read("years.json"))
headers = years.dup
headers.unshift("url")
headers.unshift("state")
states = JSON.parse(File.read("states.json"))
stateCodes = states.keys

megaMap = {}
years.each do |year|
  megaMap[year] = {}
  stateCodes.each do |state|
    megaMap[year][state] = ""
  end
end

# ap megaMap
File.open("data.csv").each do |line|
  cleanLine = line.strip.parse_csv

  year = cleanLine[0]
  state = cleanLine[1]
  val = cleanLine[4]

  if val == "NA"
    val = ""
  end

  if megaMap[year] != nil
    megaMap[year][state] = val.to_f
  end
end


CSV($stdout, headers: headers, write_headers: true) do |out|
  states.each do |key, values|
    out << CSV::Row.new(headers, []).tap do |row|
      previousYear = nil
      years.each do |year|
        row["state"] = values["label"]
        row["url"] = values["url"]
        # row[year] = megaMap[year][key]
        value = megaMap[year][key]
        if value == "" && previousYear != nil
          row[year] = previousYear
        else
          row[year] = megaMap[year][key]
          previousYear = row[year]
        end
      end
    end
  end
end