require 'json'
require 'awesome_print'
require 'csv'

seasons = JSON.parse(File.read("seasons.json"))
teamObjs = JSON.parse(File.read("teams.json"))
teams = teamObjs.keys

header_team="team"
header_url="url"

headers = seasons.dup
headers.unshift(header_url)
headers.unshift(header_team)

megaMap = {}
seasons.each do |season|
  megaMap[season] = {}
  teams.each do |team|
    megaMap[season][team] = 0
  end
end

seasons.each do |season|
  seasonDataFile = "data/" + season + ".csv"
  if File.file?(seasonDataFile)
    CSV.foreach(seasonDataFile, :headers => false) do |row|
      club = row[0]
      matches = row[1]
      wins = row[2]
      draws = row[3]
      losses = row[4]
      diff = row[5]
      points = row[6]

      if megaMap[season] != nil
        if megaMap[season][club] != nil
          megaMap[season][club] = points
        else
          STDERR.puts club + " from season: " + season + " not found!?"
        end
      end
    end
  end
end

CSV($stdout, headers: headers, write_headers: true) do |out|
  teamObjs.each do |key, values|
    out << CSV::Row.new(headers, []).tap do |row|
      previousCount = 0
      row[header_team] = values["label"]
      row[header_url] = values["url"]
      seasons.each do |season|
        if megaMap[season] != nil
          if megaMap[season][values["label"]] != nil
            row[season] = megaMap[season][values["label"]].to_i + previousCount
            previousCount = row[season]
          end
        end
      end
    end
  end
end
