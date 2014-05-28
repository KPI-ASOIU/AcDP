class NotificationsController < ApplicationController
	def index
		@activities = PublicActivity::Activity.all.order('created_at DESC')
			.select { |a| a[:parameters][:connected_to_users].include?(current_user.id)}
		
		puts params[:type]

		if !params[:type].nil?
			@activities = @activities.select{ |a| a[:trackable_type] == params[:type] }
		end

		respond_to do |format|
      format.html
      format.js
    end
	end
end
