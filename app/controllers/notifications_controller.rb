class NotificationsController < ApplicationController
	def index
		@activities = PublicActivity::Activity.all.order('created_at DESC')
										.select { |a| a[:parameters][:connected_to_users].include?(current_user.id)}
	end
end
