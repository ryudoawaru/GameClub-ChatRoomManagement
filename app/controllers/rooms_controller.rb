class RoomsController < ApplicationController
	#IndexPerPage = 10
	
	def index
		autofill_params :page => 1, :sort => 'messages_count', :order => 'DESC', :rows => 20
		@page_title = "聊天室列表"
		@rooms = Channel.count_msg.search_matches_to(params[:match]).order_by(params[:sort], params[:order]).paginate(:page => (params[:page] || 1).to_i,:per_page => params[:rows])
    
    respond_to do |format|
      format.html
    end
	end


end
