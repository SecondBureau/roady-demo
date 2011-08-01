class Setting < ActiveRecord::Base
  
  scope :available, lambda { where(:locale => $available_locales)}
  scope :include_admin_only, lambda { |i| i ? nil : where(:admin_only => false)}
  scope :search, lambda {|s| s.nil? ? nil : where("lower(name) like ? or lower(value) like ?", "%#{s.downcase}%", "%#{s.downcase}%")}
  scope :of_locale_or_default , lambda{|l|
    where("#{self.table_name}.id in (select b.id from #{self.table_name} b where b.#{identify_attr} = #{self.table_name}.#{identify_attr} and b.locale in ( :locale , :default_locale ) order by case when lower(locale) = :locale then 1 when lower(locale) = :default_locale then 2 else 3 end, locale limit 1)",
      :locale => l ,
      :default_locale => $available_locales.first
    )
  }
  
  validates_presence_of   :name,  :value,  :locale
  validates_uniqueness_of :name,  :scope => :locale
  validates_length_of     :value, :maximum => 250
  validates_length_of     :name,  :maximum => 50

  before_save :check_locale

  def self.local_value(name, locale=nil)
    s = Setting.of_locale_or_default(locale).where(:name => name).first
    s.value unless s.nil?
  end
  
  private
  
  def check_locale
    self.locale = $available_locales.first unless $available_locales.include?(self.locale)
  end
  
  def self.identify_attr
    "name"
  end
  
end
