class NotificationsController < ApplicationController
	def index
		@activities = PublicActivity::Activity.all.order('created_at DESC')
	end
end
