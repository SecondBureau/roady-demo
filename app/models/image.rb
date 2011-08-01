class Image < ActiveRecord::Base
  belongs_to :image_owner , :polymorphic => true
  mount_uploader :file , AdminImagesUploader
  before_validation :make_name_and_image_if_blank
  
  private
    def make_name_and_image_if_blank
      self.name = "lipsum" if self.name.blank?
      
      self.file = File.open(Image.unknow_image(self.image_owner_type)) if self.file.blank?
    end
    def self.unknow_image(owner_type)
      #TODO: add locale
#      current_locale = I18n.locale
      unknow_image_path = File.join(Rails.root, 'public' , 'images', 'unknown_images')
      unknow_image = 
                    case owner_type
                    when "Event"
                      "default_event_logo.png"
                    when "User" 
                      "default_user_avatar.png"
                    when "Product"
                      "default_product_logo.png"
                    else
                      "unknow_image.png"
                    end
      pp File.join( unknow_image_path , unknow_image )
      File.join( unknow_image_path , unknow_image )
    end
end
