require 'json'
require 'awesome_print'
require 'csv'
require 'date'

fileName = 'in.csv'

inHeaders = ["Lower Respiratory","Diarrhea","Tuberculosis","HIV/AIDS","Malaria","Typhoid","Whooping cough","Encephalitis(brain inflammation)","STI(not including HIV)","Measles","Hepatitis","Salmonella","Dengue","Tetanus", "COVID-19"]
outHeaders = ["date","name","category","value", "lastValue"]

csv_text = File.read(fileName)
csv = CSV.parse(csv_text, :headers => true)

megaMap = {}
CSV.foreach(fileName, headers: true).with_index(1) do |inRow, index|
  date = Date.parse(inRow["Date"]).yday()
  megaMap[date] = {}

  inHeaders.each do |inHeader|
    megaMap[date][inHeader] = inRow[inHeader]
  end
end

CSV($stdout, headers: outHeaders, write_headers: true) do |out|
  lastPeriod = {}
  megaMap.each_with_index { |(date, values),index|
    values.each do |(header,value)|
      out << CSV::Row.new(outHeaders, []).tap do |outRow|
        outRow["date"] = date
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
