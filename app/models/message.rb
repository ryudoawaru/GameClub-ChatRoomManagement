class Message < ActiveRecord::Base

	class_eval $SharedNamedScopeScript, __FILE__, __LINE__
	belongs_to :sender, :class_name => 'DzMember', :foreign_key => 'from_uid'
	belongs_to :channel

	named_scope :created_on, lambda{|day| day.blank? ? {}:{:conditions => [" date(created_at) = ? ", day]}}
	named_scope :match_content, lambda{|text| text.blank? ? {}:{:conditions => [' content LIKE ? ', "%#{text}%"]}}
end
