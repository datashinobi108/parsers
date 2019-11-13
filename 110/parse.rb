require 'json'
require 'awesome_print'
require 'csv'

dates = JSON.parse(File.read("dates.json"))
headers = dates.dup
headers.unshift("url")
headers.unshift("coin")
coins = JSON.parse(File.read("coins.json"))
coinCodes = coins.keys

megaMap = {}
dates.each do |date|
  megaMap[date] = {}
  coinCodes.each do |coin|
    megaMap[date][coin] = ""
  end
end

# ap megaMap
coins.each do |key, values|
  File.open("#{values["file"]}").each do |line|
    cleanLine = line.strip.parse_csv
    
    date = cleanLine[0]
    openPrice = cleanLine[1] 
    highPrice = cleanLine[2] 
    lowPrice = cleanLine[3] 
    closePrice = cleanLine[4] 
    volume = cleanLine[5] 
    marketCap = cleanLine[6] 

    if megaMap[date] != nil
      megaMap[date][key] = highPrice
    end
  end
end

# ap megaMap

CSV($stdout, headers: headers, write_headers: true) do |out|
  coins.each do |key, values|
    out << CSV::Row.new(headers, []).tap do |row|
      previousDate = nil
      dates.each do |date|
        row["coin"] = values["label"]
        row["url"] = values["url"]
        row[date] = megaMap[date][key]
        # value = megaMap[date][key]
        # if value == "" && previousDate != nil
        #   row[date] = previousDate
        # else
        #   row[date] = megaMap[date][key]
        #   previousDate = row[date]
        # end
      end
    end
  end
end