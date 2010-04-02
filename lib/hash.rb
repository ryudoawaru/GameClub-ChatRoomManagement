class Hash
  def self.create(keys, values)
    self[*keys.zip(values).flatten]
  end  
end