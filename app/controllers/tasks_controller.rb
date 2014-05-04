class TasksController < ApplicationController

  def new
    @task = current_user.leading_tasks.new
  end
  def create
    @task = Task.create(task_params)
    render action: 'show', id: @task.id
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    @task.update_attributes(task_params)
    render action: 'show', id: @task.id
  end

  private
  def task_params
    params.require(:task)
      .permit(:name, :description, :end_date, :status, :check_list)
  end
end
