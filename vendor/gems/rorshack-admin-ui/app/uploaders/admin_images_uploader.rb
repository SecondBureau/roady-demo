# encoding: utf-8

class AdminImagesUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick
  
  if Rails.env.production? || Rails.env.demo?
    storage :s3
  else
    storage :file
  end
  
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
   %w(jpg jpeg png)
  end
  
  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end
  
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  if Rails.env.test? || Rails.env.development? 
    def store_dir
      "tmp/assets"
    end
  end
  

  
  version :thumb do
    process :resize_to_limit => [120, 90]
  end
  
  version :normal do
    process :resize_to_limit => [400, 400]
  end

  version :medium do
    process :resize_to_limit => [500, 500]
  end
  
  #version :medium do
  #  process :resize_to_limit => [300, 225]
  #end
  
  version :large do
    process :resize_to_limit => [800, 800]
  end
  

end
