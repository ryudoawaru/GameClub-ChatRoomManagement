class MessagesController < ApplicationController
	before_filter :choice_room
	
	def index
		autofill_params :page => 1, :sort => 'id', :order => 'DESC', :rows => 20
		@messages = @room.messages.match_content(params[:match_content]).created_on(params[:created_on]).search_equal_to(params[:equal]).order_by(params[:sort], params[:order]).paginate(:page => (params[:page] || 1).to_i,:per_page => params[:rows])
		@page_title = "聊天室 [#{@room.name}] 的留言列表, 第#{@messages.current_page}頁, 共#{@messages.total_pages}頁"
		
	end

	def modify_many
		@msgs = []
		params.each do |key, val|
			if key=~ /checked\_(\d+)/
				@msgs << @room.messages.find(val.to_i)
			end
		end
		case params["ProcessAction".to_s]
			when 'delete'
				pb = lambda{|msg| msg.destroy}
			else
				redirect_to request.env['HTTP_REFERER'] || rooms_messages_path(@room)
				return false
		end
		@msgs.each{|msg| pb.call(msg)}
		@room.flush_cache_remotely
		redirect_to request.env['HTTP_REFERER'] || rooms_messages_path(@room)
	end

end
