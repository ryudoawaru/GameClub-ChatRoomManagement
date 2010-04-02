# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def url_for_forum(forum)
    "http://#{forum.host_name}"
  end

	def url_for_user(forum, user)
		"http://#{forum.host_name}/viewpro.php?uid=#{user.uid.to_s}"
	end
  
	def order_img(sort, ord)
		sort.downcase!
		ord.downcase!
		pp = params.clone
		pp.merge!(:sort => sort, :order => ord)
		url = url_for(pp)
		img_path = image_path("datagrid_sort_#{ord.downcase}.gif")
		if params[:sort].downcase == sort && params[:order].downcase == ord
			cls = 'Show'
		else
			cls = 'Hidden'
		end
		render :partial => 'layouts/order', :locals => {:class_name => cls, :url => url, :img_path => img_path}
	end


end
