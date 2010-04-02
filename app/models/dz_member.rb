require 'lib/dz'
class DzMember < ActiveRecord::Base
	set_primary_key 'uid'
  set_table_name 'cdb_members'
	include DzPublic
	named_scope :administrator, {:conditions => 'adminid = 1'}
	has_many :sent_messages, :class_name => 'Message', :foreign_key => 'from_uid'

	def administrator?
		adminid == 1
	end

	
	class << self
	
		def confirm_login(account, pwd)
			find_by_username_and_password(account, Digest::MD5.hexdigest(pwd))
		end

		def confirm_administrator_login(account, pwd)
			find_by_username_and_password_and_adminid(account, Digest::MD5.hexdigest(pwd), 1)
		end
		
	end
	
end
