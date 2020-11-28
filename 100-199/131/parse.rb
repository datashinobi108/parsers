require 'json'
require 'awesome_print'
require 'csv'

file_name = "data.csv"
meta_file = "teams.json"
csv_text = File.read(file_name)
metaInfo = JSON.parse(File.read(meta_file))

headers = ['label', 'url', 'Sport', 'Value', 'info']

inFile = CSV.parse(csv_text, :headers => true)

CSV($stdout, headers: headers, write_headers: true) do |out|
  inFile.each do |inRow|
    out << CSV::Row.new(headers, []).tap do |outRow|
      outRow['label'] = metaInfo[inRow['Team']]['label']
      outRow['url'] = metaInfo[inRow['Team']]['url']
      outRow['Sport'] = inRow['Sport'] + ' - ' + inRow['League']
      outRow['Value'] = inRow['Value'] + ' billion'
      outRow['info'] = inRow['League']
    end
  end
end
