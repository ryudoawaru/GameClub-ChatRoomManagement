module RoomsHelper
  
  def rooms_to_json(rooms)
    rooms.collect{|r|
      Hash.new(
        :id => r.id,
        :name => r.name,
        :forum => link_to(r.forum.name, r.host_name),
        :identify_code => r.identify_code
      )
    }.to_json
    
    
  end
  
end
