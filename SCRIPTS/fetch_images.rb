require "uri"
require "net/http"
require "base64"
require "byebug"
require "json"


if ARGV[0].nil?
  puts "Usage: fetch_images 'target_directory'"
  exit
end

target_directory = ARGV[0]


response = Net::HTTP.get(URI.parse('http://localhost:3000/api/photo_list'))
response = JSON.parse(response)

response['encoded_hub_images'].each do |image|
  decoded_content = Base64.decode64(image['encoded_content']) 
  filename = image['filename']
  
  File.open(target_directory+"/#{filename}", "wb") do |f|
    f.write(decoded_content)
  end
end



