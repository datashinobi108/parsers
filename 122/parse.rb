require 'json'
require 'awesome_print'
require 'csv'

dynamicVarPossible = 40
dynamicVarShown = 15
dynamicRepeat = 10

metaInfo = JSON.parse(File.read("artists.json"))
itemCodes = metaInfo.keys

megaMap = {}

File.open("data.csv").each do |line|
  cleanLine = line.strip

  arr = cleanLine.split(",")
  itemCode = arr[0]
  val = arr[1].to_f

  megaMap[itemCode] = val
end

finalArr = megaMap.sort_by {|k,v| v}.reverse.take(dynamicVarPossible).reverse

headers = []
dynamicVarPossible.times do |i|
  dynamicRepeat.times do |j|
    idx = i.to_s + "_" + j.to_s
    headers.push(idx)
  end
end
headers.unshift("url")
headers.unshift("artist")
headers.push("end")
unshiftVal = 2

CSV($stdout, headers: headers, write_headers: true) do |out|
  dynamicVarPossible.times do |i|
    out << CSV::Row.new(headers, []).tap do |row|
      itemCode = finalArr[i][0]
      itemValue = finalArr[i][1]
      row["artist"] = metaInfo[itemCode]["label"]
      row["url"] = metaInfo[itemCode]["url"]
      dynamicVarShown.times do |x|
        dynamicRepeat.times do |j|
          if (i + x < dynamicVarPossible)
            idx = (i+x).to_s + "_" + j.to_s
            row[idx] = itemValue
          end
        end
      end
      row["end"] = itemValue
    end
  end
end
