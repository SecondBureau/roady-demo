# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

seeds_path = File.join(File.dirname(__FILE__), 'seeds')

Dir["#{seeds_path}/*"].select { |file| /(yml)$/ =~ file }.sort.each do |file|
  klass = File.basename(file, '.yml').gsub(/[0-9]+\-/,'').singularize.gsub("::" , "/").camelize.constantize
  #YAML.load_file(file).each  do |key, params|
  klass.delete_all if klass == User
  YAML::load(ERB.new(IO.read(file)).result).each  do |key, params|
    conditions = {}
    klass = params['type'].constantize unless params['type'].nil?
    unless params['uniq'].nil?
      params['uniq'] = [params['uniq']] unless params['uniq'].is_a?(Array)
      params['uniq'].each {|c| conditions[c.to_sym] = params[c]}
      params.delete('uniq')
      o = klass.find(:first, :conditions => conditions) || klass.new
    else
      o = klass.new
    end
    #o.update_attributes(params)
    params.each do |att, val|
      if att[-3,3].eql?('_id')
        reflection_name = att.gsub('_id','')
        target_klass = klass.reflect_on_association(reflection_name.to_sym).klass
        val = target_klass.where(eval(val)).first.id
      end
      if att[-4,4].eql?('_ids')
        reflection_name = att.gsub('_ids','').pluralize
        target_klass = klass.reflect_on_association(reflection_name.to_sym).klass
        val = Array.wrap( val )
        vals = []
        val.each {|v| vals << target_klass.where(eval(v)).collect(&:id)}
        val = vals.flatten
      end
      o.send("#{att}=", val)
    end
    o.save(:callback => false)
  end
end
