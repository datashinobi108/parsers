require 'json'
require 'awesome_print'
require 'csv'

files = [
  'browser-ww-monthly-200901-201712.csv',
  'browser-ww-monthly-201801-201812.csv',
  'browser-ww-monthly-201901-201912.csv',
  'browser-ww-monthly-202001-202012.csv',
]

headers = ["Chrome","IE","Firefox","Safari","Opera","Edge Legacy","Yandex Browser","Maxthon","360 Safe Browser","Sogou Explorer","Chromium","Mozilla","Sony PS3","Coc Coc","QQ Browser","UC Browser","Android","AOL","SeaMonkey","Pale Moon","RockMelt","Phantom","Iron","TheWorld","Flock","Iceweasel","Other"]
megaMap = {
  "Chrome": {},
  "IE": {},
  "Firefox": {},
  "Safari": {},
  "Opera": {},
  "Edge Legacy": {},
  "Yandex Browser": {},
  "Maxthon": {},
  "360 Safe Browser": {},
  "Sogou Explorer": {},
  "Chromium": {},
  "Mozilla": {},
  "Sony PS3": {},
  "Coc Coc": {},
  "QQ Browser": {},
  "UC Browser": {},
  "Android": {},
  "AOL": {},
  "SeaMonkey": {},
  "Pale Moon": {},
  "RockMelt": {},
  "Phantom": {},
  "Iron": {},
  "TheWorld": {},
  "Flock": {},
  "Iceweasel": {},
  "Other": {}
}
years = ["2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020"]
months = ["01","02","03","04","05","06","07","08","09","10","11","12"]
allDates = []
years.each do |year|
  months.each do |month|
    compiledDate = "#{year}-#{month}"
    allDates.push(compiledDate)
  end
end

megaMap = {}
headers.each do |header|
  megaMap[header] = {}
  allDates.each do |date|
    megaMap[header][date] = ""
  end
end

files.each do |file|
  csv_text = File.read(file)

  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    date = row["Date"]
    headers.each do |header|
      if !row[header].nil?
        val = row[header]

        if !megaMap[header].nil?
          megaMap[header][date] = val
        end
      end
    end
  end
end

outHeaders = ["Date","Chrome","IE","Firefox","Safari","Opera","Edge Legacy","Yandex Browser","Maxthon","360 Safe Browser","Sogou Explorer","Chromium","Mozilla","Sony PS3","Coc Coc","QQ Browser","UC Browser","Android","AOL","SeaMonkey","Pale Moon","RockMelt","Phantom","Iron","TheWorld","Flock","Iceweasel","Other"]

CSV($stdout, headers: outHeaders, write_headers: true) do |out|
  allDates.each do |date|
    out << CSV::Row.new(outHeaders, []).tap do |row|
      headers.each do |header|
        row["Date"] = date
        row[header] = megaMap[header][date]
      end
    end
  end
end
