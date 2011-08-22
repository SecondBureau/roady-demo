#configuration of s3
Rails.configuration.after_initialize do
  if Rails.env.test? 
    CarrierWave.configure do |config|
      config.storage = :file
      config.enable_processing = false
    end
  elsif Rails.env.development?
    CarrierWave.configure do |config|
      config.storage = :file
      config.enable_processing = true
    end
  else

    CarrierWave.configure do |config|
      config.storage              = :s3
      config.s3_access_key_id     = $s3_access_key_id
      config.s3_secret_access_key = $s3_secret_access_key
      config.s3_bucket            = $s3_bucket
      config.s3_region            = 'eu-west-1'
      config.s3_access_policy     = :public_read
      config.s3_headers           = {'Cache-Control' => 'max-age=315576000'}
      
    end
  end
end
