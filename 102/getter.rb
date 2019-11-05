require 'json'
require 'awesome_print'
require 'open-uri'

countries = JSON.parse(File.read("countries.json"))

countries.each do |key, values|
  countryName = values["label"].gsub(" ","_")
  url = "https://dynamospanish.com/wp-content/uploads/flags/images/#{countryName}/2/large/#{countryName}.png"
  begin
    file = open(url)
    ap url
  rescue OpenURI::HTTPError => e
    if e.message == '404 Not Found'
      STDERR.puts "File: #{countryName}.png not found"
      ap "******"
    elsif e.message == '500 Internal Server Error'
      STDERR.puts "500: Server Error for country #{countryName}"
    else
      raise e
    end
  end
end
