class EventsController < ApplicationController
	def new
    @event = current_user.leading_events.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      render action: 'show', id: @event.id
    else
      redirect_to :back
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def edit
    @event = Event.find(params[:id])
    @event.date = local_time_format(@event.date) if !@event.date.nil?
  end

  def update
    @event = Event.find(params[:id])
    @event.update_attributes(event_params)
    redirect_to event_path(@event.id)
  end

  def index
  	if !params[:search].nil?
      params[:place] ||= ''
      params[:author] ||= User.all.pluck(:id).join(" ")      
      params[:event_start_date] = local_time_format(Time.now - 1000.years) if validate_date_strings(params[:event_start_date])
      params[:event_end_date] = local_time_format(Time.now + 1000.years) if validate_date_strings(params[:event_end_date])
      params[:creation_start_date] = local_time_format(Time.now - 1000.years) if validate_date_strings(params[:creation_start_date])
      params[:creation_end_date] = local_time_format(Time.now + 1000.years) if validate_date_strings(params[:creation_end_date])
      @events = Event.with_name(params[:name])
                .with_place(params[:place])
                .with_author(params[:author].split(" "))
                .with_date(local_time_convert(params[:event_start_date]), local_time_convert(params[:event_end_date]))
                .created_at(local_time_convert(params[:creation_start_date]), local_time_convert(params[:creation_end_date]))   
                .order("created_at DESC").uniq

      if !params[:guests].nil?
        # This is made, because params[:guest] can be [1, [2, 3]]
        params[:guests] = params[:guests].join(" ")
        @events = @events.with_guests(params[:guests].split(" ")).order("created_at DESC").uniq
      end

      respond_to do |format|
        format.html
        format.js
      end
    else
      @events = Event.joins('LEFT JOIN events_has_guests ON events.id = events_has_guests.event_id')
        .where('events_has_guests.guest_id = ? OR events.author_id = ?', current_user.id, current_user.id)
        .uniq.order("created_at DESC")
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    redirect_to :back
  end

  private
  def event_params
    params.require(:event)
      .permit(:name, :description, :date, :place, :plan)
      .merge({ guests: User.where(id: params[:guests]), author_id: current_user.id })
  end

  def local_time_convert(time)
    DateTime.strptime(time, I18n.t('time.formats.short'))
  end

  def local_time_format(time)
    I18n.l(time, format: :short)
  end
  
  def validate_date_strings(date_string)
    date_string.nil? || 	date_string.empty?
  end
end
