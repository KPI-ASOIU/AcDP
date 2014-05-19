class TasksController < ApplicationController
  authorize_resource
  include PublicActivity::StoreController 
  
  def new
    @task = current_user.leading_tasks.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save!
      render action: 'show', id: @task.id
    else
      redirect_to :back
      flash[:error] = @task.errors.full_messages.join('. ')
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
    @task.end_date = local_time_format(@task.end_date) if !@task.end_date.nil?
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(task_params)
      redirect_to task_path(@task.id)
    else
      redirect_to :back
      flash[:error] = @task.errors.full_messages.join('. ')
    end
  end

  def index
    if !params[:search].nil?
      params[:status] ||= Task::STATUS
      params[:author] ||= User.all.pluck(:id).join(" ")      
      params[:exec_start_date] = local_time_format(Time.now - 1000.years) if validate_date_strings(params[:exec_start_date])
      params[:exec_end_date] = local_time_format(Time.now + 1000.years) if validate_date_strings(params[:exec_end_date])
      params[:creation_start_date] = local_time_format(Time.now - 1000.years) if validate_date_strings(params[:creation_start_date])
      params[:creation_end_date] = local_time_format(Time.now + 1000.years) if validate_date_strings(params[:creation_end_date])
      @tasks = Task.with_name(params[:name])
                .with_status(params[:status])
                .with_author(params[:author].split(" "))
                .with_end_date(local_time_convert(params[:exec_start_date]), local_time_convert(params[:exec_end_date]))
                .created_at(local_time_convert(params[:creation_start_date]), local_time_convert(params[:creation_end_date]))   
                .order("created_at DESC").uniq

      if !params[:executor].nil?
        # This is made, because params[:executor] can be [1, [2, 3]]
        params[:executor] = params[:executor].join(" ")
        @tasks = @tasks.with_executors(params[:executor].split(" ")).order("created_at DESC").uniq
      end

      respond_to do |format|
        format.html
        format.js
      end
    else
      @tasks = Task.joins('LEFT JOIN executing_tasks_executors ON tasks.id = executing_tasks_executors.task_id')
        .where('executing_tasks_executors.executor_id = ? OR tasks.user_id = ?', current_user.id, current_user.id)
        .uniq.order("created_at DESC")
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
              checklists_attributes: [:id, :done, :name, :_destroy])
      .merge({ executors: User.where(id: params[:executors]), user_id: current_user.id })
  end
  
  def local_time_convert(time)
    DateTime.strptime(time, I18n.t('time.formats.short'))
  end

  def local_time_format(time)
    I18n.l(time, format: :short)
  end
  
  def validate_date_strings(date_string)
    date_string.nil? || date_string.empty?
  end
end
