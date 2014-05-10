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
    @task.end_date = I18n.l(@task.end_date, format: :short)
  end

  def update
    @task = Task.find(params[:id])
    @task.update_attributes(task_params)
    render action: 'show', id: @task.id
  end

  def index
    if !params[:name].nil? || !params[:status].nil? || ! params[:author].nil?
      params[:name] ||= '*'
      params[:status] ||= Task::STATUS
      params[:author] ||= User.all.pluck(:id).join(" ")
      @tasks = Task.with_name(params[:name])
                .with_status(params[:status])
                .with_author(params[:author].split(" "))
                .with_end_date(local_time_convert(params[:exec_start_date]), local_time_convert(params[:exec_end_date]))
                .created_at(local_time_convert(params[:creation_start_date]), local_time_convert(params[:creation_end_date]))   
      if !params[:executor].nil?
        # This is made, because params[:executor] can be [1, [2, 3]]
        params[:executor] = params[:executor].join(" ")
        @tasks = @tasks.with_executors(params[:executor].split(" ")) 
      end
    else
      @tasks = Task.joins(:executors)
        .where('executing_tasks_executors.executor_id = ? OR tasks.user_id = ?', current_user.id, current_user.id)
    end
  end

  def destroy
    Task.find(params[:id]).destroy
    redirect_to :back
  end

  private
  def task_params
    params.require(:task)
      .permit(:name, :description, :end_date, :status, :check_list, \
              checklists_attributes: [:id, :done, :name])
      .merge({ executors: User.where(id: params[:executors]), user_id: current_user.id })
  end

  def local_time_convert(time)
    DateTime.strptime(time, I18n.t('time.formats.short'))
  end
end
