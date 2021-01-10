require 'json'
require 'awesome_print'
require 'csv'
require 'date'

fileName = 'merged.csv'

inHeaders = ["Chrome","IE","Firefox","Safari","Opera","Edge Legacy","Yandex Browser","Maxthon","360 Safe Browser","Sogou Explorer","Chromium","Mozilla","Sony PS3","Coc Coc","QQ Browser","UC Browser","Android","AOL","SeaMonkey","Pale Moon","RockMelt","Phantom","Iron","TheWorld","Flock","Iceweasel","Other"]
outHeaders = ["date","name","category","value"]
baseYear = 2009

csv_text = File.read(fileName)

csv = CSV.parse(csv_text, :headers => true)
CSV($stdout, headers: outHeaders, write_headers: true) do |out|
  csv.each do |inRow|
    dateStringArr = inRow["Date"].split('-')
    year = dateStringArr[0].to_i
    month = dateStringArr[1].to_i
    dateCount = ((year - baseYear) * 12) + month - 1
    inHeaders.each do |inHeader|
      out << CSV::Row.new(outHeaders, []).tap do |outRow|
        outRow["date"] = dateCount.to_s
        outRow["name"] = inHeader
        outRow["value"] = inRow[inHeader]
      end
    end
  end
end
