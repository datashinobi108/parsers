require 'json'
require 'awesome_print'
require 'csv'
require 'date'

fileName = 'in.csv'

inHeaders = ["alone","children","co-workers","parents, siblings & other family","friends","partner"]
outHeaders = ["date","name","category","value", "lastValue"]

csv_text = File.read(fileName)
csv = CSV.parse(csv_text, :headers => true)

megaMap = {}
CSV.foreach(fileName, headers: true).with_index(1) do |inRow, index|
  year = inRow["Year"]
  megaMap[year] = {}

  inHeaders.each do |inHeader|
    megaMap[year][inHeader] = inRow[inHeader]
  end
end

CSV($stdout, headers: outHeaders, write_headers: true) do |out|
  lastPeriod = {}
  megaMap.each_with_index { |(year,values),index|
    values.each do |(header,value)|
      out << CSV::Row.new(outHeaders, []).tap do |outRow|
        outRow["date"] = year
        outRow["name"] = header
        outRow["value"] = value
        if lastPeriod == {}
          outRow["lastValue"] = value
        else
          outRow["lastValue"] = lastPeriod[header]
        end
      end
    end
    lastPeriod = values
  }
end
