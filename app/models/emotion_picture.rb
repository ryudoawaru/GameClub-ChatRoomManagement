class EmotionPicture < ActiveRecord::Base
	class_eval $SharedNamedScopeScript, __FILE__, __LINE__
	belongs_to :channel

  validates_presence_of :key_code
  validates_presence_of :img_url
  validates_length_of :key_code, :within => 2..5
  validates_uniqueness_of :key_code, :scope => :channel_id


  
end
