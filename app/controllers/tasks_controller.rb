class TasksController < ApplicationController
	def create
		Task.create(task_params)
		render action: 'show'
	end

	def show
		@task = Task.find(task_params)
	end

	private
	def task_params
		params.require(:task)
			.permit(:name, :description, :end_date, :status, :check_list)
			.merge(author: current_user)
	end
end
