require 'rubygems'
require 'anemone'
require 'mechanize'
require 'youtube_it'

client = YouTubeIt::Client.new
url = ARGV.shift
puts "Crawling url: #{url}"
agent = Mechanize.new
page = agent.get(url)
page.images_with(:src => /default.jpg$/).each do |link|
  url = link.src
  url = url.gsub(/^.*com\/vi\//,'').gsub(/\/default.jpg$/,'')
  ytid = url.to_s
  puts "#{ytid} -> Desc:  #{client.video_by(ytid).description}"
end
abort;


Anemone.crawl(url, :depth_limit => 1) do |anemone|
  #anemone.skip_links_like /php.*$/
  anemone.on_pages_like(/lv\-.*$/) do |page|
     puts page.url
     pg = agent.get(page.url)
     p pg.links
  end
end  
puts "#####################"
abort;

Anemone.crawl(url, :verbose => true, :depth_limit => 1, :skip_query_strings => true) do |anemone|
  titles = []
  anemone.on_every_page { |page| titles.push page.doc.at('title').inner_html rescue nil }
  anemone.after_crawl { puts titles.compact.sort }
end

