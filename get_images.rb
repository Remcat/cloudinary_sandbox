require 'rubygems'
require 'nokogiri'
require 'mechanize'

for url in ARGV
#
#https://res.cloudinary.com/<your Cloudinary account's cloud name>/<resource_type>/upload/<mapped upload folder prefix>/<partial path of remote resource>
#
#https://res.cloudinary.com/<your Cloudinary account's cloud name>/image/fetch/
#
#  puts url
#  :cloud_name = "rabdelazim"
#  :resource_type = "image"
#  :fetch = "fetch"
#  :upload = "upload"
  account_info = {:cloudinary_host => "https://res.cloudinary.com", :cloud_name => "rabdelazim", :resource_type => "image"}

  cloudinary_base = account_info.values.join("/")

  use_fetch  = cloudinary_base + "/fetch"
  use_upload = cloudinary_base + "/upload"

  puts use_fetch

  url = "https://" + url unless url.start_with?("http")
  #url += "/" unless url[-1] == "/"
  host = URI.parse(url).host.downcase
  path = URI.parse(url).path.downcase
  agent = Mechanize.new
  begin
    response = agent.get(url)
  rescue Mechanize::ResponseCodeError
  #doc = Nokogiri::HTML(URI.open(url))
  end
  path_name = path.gsub("/","-")
  
  transformations = "/"
  html_doc = Nokogiri::HTML(response.body)
  if path.match? /people|persons|person|man|woman/
#    transformations = ", " unless transformations = "/"
    transformations += "g_face"
  end

  transformations += "/" unless transformations.nil?
  puts transformations
  
  images = html_doc.xpath("//img")
  for image in images
    puts host + image["src"]
    puts "RESOLVER " + agent.resolve(image["src"]).to_s 
    puts use_fetch + transformations + agent.resolve(image["src"]).to_s

    image["src"] = use_fetch + transformations + agent.resolve(image["src"]).to_s
  end

  file_extension = ".html" unless path.end_with? "html"

  fp = File.new("cloudinarified-#{host}#{path_name}#{file_extension}", "w")
  fp.write(html_doc)
  fp.close
end
