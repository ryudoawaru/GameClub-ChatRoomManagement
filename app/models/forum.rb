class Forum < ActiveRecord::Base
	establish_connection YAML.load_file(File.join(Rails.root, "config/database.yml"))['forum']
  set_primary_key 'id'
  set_table_name 'billboards'
  class_eval $SharedNamedScopeScript, __FILE__, __LINE__
  
  has_many :channels, :order => "channels.id"
  
  def host_name
    "#{self.subdn}.gameclub.tw"
  end
  
  
end
