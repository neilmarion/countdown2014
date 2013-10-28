class ImageUploader 
  @queue = :image_uploads_queue

  def self.perform(auth_id, access_token)
      file_name = ProcessImage.process(auth_id)
      #upload_image(access_token, file_name)

      graph = Koala::Facebook::API.new(access_token) 
      graph.put_picture("#{Rails.root}/tmp/images/#{file_name}.jpg", {'message'=> 'test'})

      ProcessImage.remove_photo(file_name)
  end
end
