class TasksController < ApplicationController
  authorize_resource
  before_action :set_current_user

  include PublicActivity::StoreController 
  include TasksHelper
  
  def new
    @task = current_user.leading_tasks.new
  end

  def create
    @task = Task.new(task_params)
    if params[:documents].present?
      @task.documents = Document.find(params[:documents])
    end
    if @task.save
      redirect_to task_path(@task.id)
    else
      redirect_to :back, flash: { error: @task.errors.full_messages.join('. ') }
    end
  end

  def show
    if find_task_by_id and @task.author != current_user and !@task.executors.include?(current_user)
      redirect_to tasks_path, flash: { error: t('tasks.errors.not_engaged') }
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    if find_task_by_id and @task.author != current_user
      redirect_to tasks_path, flash: { error: t('tasks.errors.no_edit') }
    else
      @task.end_date = local_time_format(@task.end_date) if @task.end_date.present?
    end
  end

  def update
    @task = Task.find(params[:id])
    @old_status = @task.status
    @old_execs = @task.executors.sort
    if params[:documents].present?
      @task.documents = Document.find(params[:documents]).uniq
    else
      @task.documents.destroy_all
    end
    if @task.update_attributes(task_params)
      track_specific_fields or create_activity('task.update', @task.name)
      redirect_to task_path(@task.id)
    else
      redirect_to :back, flash: { error: @task.errors.full_messages.join('. ') }
    end 
  end

  def update_checklist
    @task = Task.find(params[:id])
    checklist = @task.checklists
    checklist.each_with_index { |c, i| 
      c.done = params['done' << i.to_s] or false
      c.save
    }
    redirect_to task_path(@task.id)
  end

  def index
    if params[:search].present?
      fix_params
      puts params[:exec_start_date]
      puts params[:exec_end_date]
      @tasks = Task.connected_to_me
                .with_name(params[:name])
                .with_status(params[:status])
                .with_author(params[:author].split(" "))
                .created_at(params[:creation_start_date], params[:creation_end_date])
                .with_end_date(params[:exec_start_date], params[:exec_end_date])
                .order("created_at DESC").uniq

      if params[:executor].present?
        @tasks = @tasks.with_executors(params[:executor].flatten).order("created_at DESC").uniq
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
    @only_executor = !authored_any_task?(@tasks)
  end

  def destroy
    (@task = Task.find(params[:id])).destroy
    redirect_to :back
  end

  private
  def find_task_by_id
    begin
      @task = Task.find(params[:id])
    rescue
      redirect_to tasks_path, flash: { error: t('tasks.errors.not_found') } and false
    end
  end

  def task_params
    params.require(:task)
      .permit(:name, :description, :end_date, :status, :check_list, \
              checklists_attributes: [:id, :done, :name, :_destroy])
      .merge({ executors: User.where(id: params[:executors]), user_id: current_user.id })
  end

  def to_datetime(date_string)
    Time.parse(date_string, '%d.%m.%Y')
  end

  def local_time_format(time)
    I18n.l(time, format: :short)
  end
  
  def date_invalid?(date_string)
    date_string.nil? || date_string.empty?
  end

  def fix_params
    params[:status] ||= Task::STATUS
    params[:author] ||= User.all.pluck(:id).join(" ")
    params[:creation_start_date] = date_invalid?(params[:creation_start_date]) ? Time.now - 1000.years : 
                                                            to_datetime(params[:creation_start_date])
    params[:creation_end_date] = date_invalid?(params[:creation_end_date]) ? Time.now + 1000.years : 
                                                          to_datetime(params[:creation_end_date])
    params[:exec_start_date] = date_invalid?(params[:exec_start_date]) ? Time.now - 1000.years : 
                                                        to_datetime(params[:exec_start_date])
    params[:exec_end_date] = date_invalid?(params[:exec_end_date]) ? Time.now + 1000.years : 
                                                      to_datetime(params[:exec_end_date])
  end

  def create_activity(title, summary)
    @task.create_activity(key: title, owner: current_user, 
      params: {
        summary: summary,
        trackable_id: @task.id 
      },
      connected_to_users: ' ' << [@task.author.id].concat(@task.executors.map { |e| e.id }).join(' ') << ' ')
  end

  def track_specific_fields
    status_changed = (@old_status != task_params[:status])
    executors_changed = (@old_execs != task_params[:executors].sort)
    create_activity('task.status_changed', @task.status) if status_changed
    create_activity('task.executors_changed', @task.executors.map{|e| e.full_name}*(", ")) if executors_changed
    status_changed || executors_changed
  end
end
