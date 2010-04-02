require 'rest_client'
class Channel < ActiveRecord::Base
	class_eval $SharedNamedScopeScript, __FILE__, __LINE__
  belongs_to :forum
  has_many :messages
  has_many :emotion_pictures
	named_scope :count_msg, {
		:select => 'channels.*, mc.messages_count', 
		:joins => "JOIN (SELECT channel_id,COUNT(id) AS messages_count FROM messages GROUP BY channel_id ORDER BY messages_count DESC) AS mc ON mc.channel_id = channels.id"
	}
	
  TokenForFlush = 'ji394sinatra'
  HostNameOfChat = 'freechat.gameclub.tw'
  
	def flush_cache_remotely
		auth_header = {'AUTH_CODE' => Digest::MD5.hexdigest("#{Time.now.to_i.to_s[0..6]}-#{TokenForFlush}")}
		begin
			res = RestClient.get("http://#{HostNameOfChat}/chat_rooms/#{self.id}/flush_cache", auth_header)
		rescue => ex
			logger.warn "清除快取失敗!資訊：#{ex.inspect}"
			return false
		end
		return true
	end
	  
end
