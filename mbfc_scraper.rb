require "nokogiri"
require "httparty"
require "json"

news_sources = JSON.parse(File.read("./mbfc.json"))
url = "https://mediabiasfactcheck.com/"
bias = ARGV[0]
fact_reporting = ["VERY HIGH", "HIGH", "MOSTLY FACTUAL", "MIXED", "LOW", "VERY LOW"]

news_sources[bias] = Array.new
unparsed_page = HTTParty.get(url + bias)
parsed_page = Nokogiri::HTML(unparsed_page)
sources = parsed_page.css("table#mbfc-table tbody tr td")

sources.each_with_index do |src, src_index|
    print "#{src_index}: "
    sname = src.css("a")
    puts sname.text.strip
    
    next if sname.empty?

    sobj = {"name" => sname.text.strip, "url" => sname[0].attributes["href"].value }
    parsed_src_url = Nokogiri::HTML(HTTParty.get(sobj["url"]))
    factual_reporting = parsed_src_url.css("p")

    factual_reporting.each do |fact|
        fr_found = false

        fact_reporting.each do |fr|
            if fact.text.match(fr)
                sobj["factual-reporting"] = fr
                puts "Factual Reporting: #{fr}"
                fr_found = true
                break
            end
        end

        break if fr_found
    end

    news_sources[bias] << sobj
end

File.open("mbfc.json", "w") { |file| file.puts JSON.pretty_generate(news_sources) }
