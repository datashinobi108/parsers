require 'json'
require 'awesome_print'
require 'csv'

class String
  def titleize
    self.split(" ").map{|word| word.capitalize}.join(" ")
  end
end

dates = JSON.parse(File.read("dates.json"))
dates_sorted = JSON.parse(File.read("dates_sorted.json"))
parties = JSON.parse(File.read("parties.json"))

megaMap = {}
dates.each do |date|
  megaMap[date] = {}
  parties.each do |party|
    megaMap[date][party] = 0
  end
end

dateIdx = 0;
File.open("data.txt").each do |line|
  cleanLine = line.strip

  if (cleanLine == "")
    dateIdx += 1
  else
    arr = cleanLine.split(',')
    party = arr[0]
    count = arr[1]

    megaMap[dates[dateIdx]][party] = count;
  end
end

CSV($stdout, headers: dates_sorted, write_headers: true) do |out|
  parties.each do |party|
    out << CSV::Row.new(dates_sorted, []).tap do |row|
      previousCount = 0
      dates_sorted.each do |date|
        row[date] = megaMap[date][party].to_i + previousCount
        previousCount = row[date]
      end
    end
  end
end
