class Event < ActiveRecord::Base
  has_and_belongs_to_many :products
  
  accepts_nested_attributes_for :products
  
  has_many :images , :class_name => "Image" , :as => "image_owner" , :dependent => :destroy
  accepts_nested_attributes_for :images , :allow_destroy => true

  before_validation :make_image
  before_validation :lipsum
  
  scope :of_locale_or_default , lambda{|l|
    where("#{self.table_name}.id in (select b.id from #{self.table_name} b where b.#{identify_attr} = #{self.table_name}.#{identify_attr} and b.locale in ( :locale , :default_locale ) order by case when lower(locale) = :locale then 1 when lower(locale) = :default_locale then 2 else 3 end, locale limit 1)",
      :locale => l ,
      :default_locale => $available_locales.first
    )
  }
  scope :unexpired , lambda{
    where("events.end_date > ?" , Time.current)
  }
  
  private
    def self.identify_attr
      "code"
    end
    
    def make_image
      self.images.build if self.images.empty?
    end
    
    def lipsum
      self.title = Lipsum.generate(:words => 5 + rand(10), :start_with_lipsum => false , :locale => locale ) if self.description.eql?'lipsum' 
      self.description   = Lipsum.generate(:words => 30 + rand(10), :start_with_lipsum => false , :locale => locale ) if self.description.eql?'lipsum' 
      self.content       = Lipsum.generate(:words => 150 + rand(10), :start_with_lipsum => false , :locale => locale  ) if self.content.eql?'lipsum' 
    end

end
