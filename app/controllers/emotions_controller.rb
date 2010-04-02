class EmotionsController < ApplicationController
	before_filter :choice_room

	def index
		autofill_params :page => 1, :sort => 'id', :order => 'DESC', :rows => 15
		@emotions = @room.emotion_pictures.order_by(params[:sort], params[:order]).paginate(:page => params[:page].to_i,:per_page => params[:rows])
		@page_title = "聊天室 [#{@room.name}] 的表情列表, 第#{@emotionscurrent_page}頁, 共#{@emotionstotal_pages}頁"
		@new_emp = @room.emotion_pictures.new
	end

	def create
		@new_emp = @room.emotion_pictures.build(params[:new_emp])
		if @new_emp.save
			flash[:notice] = '成功新增一筆'
			redirect_to room_emotions_path(@room)
		else
			flash[:warning] = "新增失敗!錯誤訊息為:#{@new_emp.errors.full_messages}"
			redirect_to :back
		end
	end
	
	def update
		@emp = @room.emotion_pictures.find(params[:id])
		if @emp.update_attributes(params[:emotion_picture])
			flash[:info] = '修改成功'
		else
			flash[:warning] = '修改失敗!'
		end
		redirect_to :back
	end

	def modify_many
		@emotions = @room.emotion_pictures.find(params[:emp])
		case params["ProcessAction".to_s]
			when 'delete'
				pb = lambda{|emp| emp.destroy}
			else
				redirect_to request.env['HTTP_REFERER'] || rooms_emotions_path(@room)
				return false
		end
		@emotions.each{|emp| pb.call(emp)}
		redirect_to request.env['HTTP_REFERER'] || rooms_emotions_path(@room)
	end
	
end
