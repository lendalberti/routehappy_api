http://localhost:3000/



Reference Documentation

These are the REST API endpoint reference docs.

POST api/photo_upload
      Example usage:

        require "uri"
        require "net/http"
        require "base64"


        if ARGV[0].nil?
          puts "Usage: upload_image 'filename'"
          exit
        end

        image = ARGV[0]  
        m = image.match(/png|jpg/)

        if m
          filetype = m[0]
          filename = File.basename(image)

          encoded_content = Base64.encode64( File.open(image, "rb").read )
          postParams = { 'encoded_content' => encoded_content, 'filename' => filename, 'filetype' => filetype }
          print "#{filename}..."
          response = Net::HTTP.post_form(URI.parse( 'http://localhost:3000/api/photo_upload' ), postParams )
          
          if response.code == '200'
            puts "saved!"
          else
            puts "NOT saved!"
          end
        end


        >> ruby upload_image.rb ~/Pictures/black_cat.png 


      
GET api/photo_list
    Example usage:

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



        >> mkdir FETCHED_IMAGES
        >> ruby fetch_images.rb ./FETCHED_IMAGES

    