class ApiController < ApplicationController

  MIN = 350
  MAX = 5000
  HUB_IMAGES = 'API_HUB_IMAGES'

  def home
    # display some documentation...
  end

  def photo_upload
    error_text = ''

    if params['encoded_content'] && params['filename']
      if params['image_X'].to_i.between?(MIN,MAX) && params['image_Y'].to_i.between?(MIN,MAX)
        filename =  params['filename']

        decoded_content = Base64.decode64(params['encoded_content']) 
        File.open(HUB_IMAGES+"/#{filename}", "wb") do |f|
          f.write(decoded_content)
        end 
      else
        error_text = 'Wrong resolution'
      end
    else
      error_text = 'Missing file content and/or name'
    end

    if error_text.blank?
      render json: {status: "success"} 
    else
      render json: {status: "error", message: error_text }
    end
  end



  def photo_list
    encoded_hub_images = []

    Dir.foreach( HUB_IMAGES ) do |item|
      next if item == '.' or item == '..'
      File.open( HUB_IMAGES + "/#{item}", "rb") do |f|
        buffer = f.read
        encoded_hub_images.push({ encoded_content: Base64.encode64(buffer),
                                  filename: item  })
      end
    end

    render json: { encoded_hub_images: encoded_hub_images } 
  end


end
