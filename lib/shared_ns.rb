  
  named_scope :search_less_than, lambda{ |params| 
    return {} if params.blank? || !params.is_a?(Hash)
    conds = ['']
    params.each do |field, value|
      if !columns_hash[field.to_s].blank? && !value.blank? && [:float, :integer].include?(columns_hash[field.to_s].type)
        conds[0].concat " AND " if conds.size > 1
        conds[0].concat " #{field} < ? "
        case columns_hash[field.to_s].type
          when :integer
            conds << value.to_i
          when :float
            conds << value.to_f
          else
        end
      end
    end
    {:conditions => conds}
  }
  
  named_scope :search_greater_than, lambda{ |params| 
    return {} if params.blank? || !params.is_a?(Hash)
    conds = ['']
    params.each do |field, value|
      if !columns_hash[field.to_s].blank? && !value.blank? && [:float, :integer].include?(columns_hash[field.to_s].type)
        conds[0].concat " AND " if conds.size > 1
        conds[0].concat " #{field} > ? "
        case columns_hash[field.to_s].type
          when :integer
            conds << value.to_i
          when :float
            conds << value.to_f
          else
        end
      end
    end
    {:conditions => conds}
  }
  
  named_scope :search_equal_to, lambda { |params|
    return {} if params.blank?
    conds = ['']
    params.each do |field, value|
      if !value.blank?  #&&!columns_hash[field.to_s].blank?
        conds[0].concat " AND " if conds.size > 1
        conds[0].concat " #{field} = ? "
        case columns_hash[field.to_s].type
          when :boolean
            conds << (value.to_i > 0 ? (true):(false))
          when :integer
            conds << value.to_i
          when :float
            conds << value.to_f
          when :datetime
            conds << Time.parse(value)
          when :date
            conds << Date.parse(value)
          else
            conds << value
        end
      end
    end
    {:conditions => conds}
  }
  
  named_scope :greater_than, lambda{ |col, val|
    return {} if (col.blank? || val.blank?) || !([:integer, :float].include?(columns_hash[col.to_s].type))
    val = ((columns_hash[col.to_s].type == :integer) ? (val.to_i):(val.to_f))
    {:conditions => [" #{col} > ? ", val]}
  }
  named_scope :less_than, lambda{ |col, val|
    return {} if (col.blank? || val.blank?) || !([:integer, :float].include?(columns_hash[col.to_s].type))
    val = ((columns_hash[col.to_s].type == :integer) ? (val.to_i):(val.to_f))
    {:conditions => [" #{col} < ? ", val]}
  }
  
  named_scope :search_matches_to, lambda{ |params|
    return {} if params.blank?
    conds = ['']
    params.each do |field, value|
      unless value.blank?
        conds[0].concat " AND " if conds.size > 1
        conds[0].concat " #{field} LIKE ? "
        conds << "%#{value.to_s}%"
      end
    end
    {:conditions => conds}
  }
  
  named_scope :match, lambda{ |col, val|
    return {} if (col.blank? || val.blank?)
    return {} unless [:string, :text].include?(columns_hash[col.to_s].type)
    {:conditions => [" #{col} LIKE ? ", "%#{val}%"]}
  }
  
  named_scope :equal, lambda { |col, val|
    if val.blank?
      return {}
    else
      case columns_hash[col.to_s].type
        when :integer
          val = val.to_i
        when :float
          val = val.to_f
        when :datetime
          val = Time.parse(val)
        when :date
          val = Date.parse(val)
      end
      {:conditions => ["#{col} = ?", val]}
    end
  }
  
  named_scope :order_by, lambda{ |odb, pow|
    power = pow.blank? ? ("ASC"):(pow); order = odb.blank? ? (primary_key):(odb)
    {:order => "#{order} #{power}"}
  }