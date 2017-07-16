require "uri"
require "net/http"
require "base64"
require "byebug"
require "json"


if ARGV[0].nil?
  puts "Usage: upload_image 'filename'"
  exit
end

image = ARGV[0]  
matches = image.match(/png|jpg/)
file_dimension = IO.read(image)[0x10..0x18].unpack('NN')

if matches
  filename = File.basename(image)
  encoded_content = Base64.encode64( File.open(image, "rb").read )
  
  postParams = {  'encoded_content' => encoded_content, 
                  'filename'        => filename, 
                  'image_X'         => file_dimension[0], 
                  'image_Y'         => file_dimension[1] }

  print "#{filename}..."
  response = Net::HTTP.post_form(URI.parse( 'http://localhost:3000/api/photo_upload' ), postParams )
  response =  JSON.parse(response.body)


  if response['status'] == 'success'
    puts "saved!"
  else
    puts "NOT saved -- #{response['message']}"
  end
end



