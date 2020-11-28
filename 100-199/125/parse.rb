require 'json'
require 'awesome_print'
require 'csv'

dynamicVarPossible = 100
dynamicVarShown = 7
dynamicRepeat = 10
endCount = dynamicVarPossible - dynamicVarShown
additionalHeaders = ["label","url"]

metaInfo = JSON.parse(File.read("celebrities.json"))
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
additionalHeaders.each do |header|
  headers.push(header)
end
unshiftVal = additionalHeaders.count
dynamicVarPossible.times do |i|
  dynamicRepeat.times do |j|
    idx = i.to_s + "_" + j.to_s
    headers.push(idx)
  end
end
endCount.times do |y|
  headers.push("end_" + y.to_s)
end

CSV($stdout, headers: headers, write_headers: true) do |out|
  dynamicVarPossible.times do |i|
    out << CSV::Row.new(headers, []).tap do |row|
      itemCode = finalArr[i][0]
      itemValue = finalArr[i][1]
      additionalHeaders.each do |header|
        row[header] = metaInfo[itemCode][header]
      end
      dynamicVarShown.times do |x|
        dynamicRepeat.times do |j|
          if (i + x < dynamicVarPossible)
            idx = (i+x).to_s + "_" + j.to_s
            row[idx] = itemValue
          end
        end
      end
      endIndex = endCount-i-1
      (endCount - endIndex).times do |e|
        if (endCount - e - 1 >= 0)
          row["end_" + (endCount - e - 1).to_s] = itemValue
        end
      end
    end
  end
end
