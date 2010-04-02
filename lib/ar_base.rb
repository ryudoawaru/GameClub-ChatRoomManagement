class ActiveRecord::Base
  
  #self.abstract_class = true
  
  
  
  def self.last_page_for(per_page, conditions = nil)
    te = self.count(self.primary_key, :conditions => conditions)
    if te % per_page > 0
      te / per_page + 1
    else
      te / per_page
    end
  end
  
#  named_scope :equal, lambda { |col, val|
#    return {} if val.blank?
#    case columns_hash[col.to_s].type
#      when :integer
#        val = val.to_i
#      when :float
#        val = val.to_f
#      when :datetime
#        val = Time.parse(val)
#      when :date
#        val = Date.parse(val)
#    end
#    {:conditions => ["#{col} = ?", val]}
#  }
#
#  named_scope :search_equal_to, lambda { |params|
#    return {} if params.blank?
#    conds = ['']
#    params.each do |field, value|
#      continue if columns_hash[field.to_s].blank?
#      conds[0].concat " AND " if conds.size > 1
#      conds[0].concat " #{field} = ? "
#      case columns_hash[field.to_s].type
#        when :integer
#          conds << value.to_i
#        when :float
#          conds << value.to_f
#        when :datetime
#          conds << Time.parse(value)
#        when :date
#          conds << Date.parse(value)
#        else
#          conds << value
#      end
#      
#    end
#    {:conditions => conds}
#  }

end