class EventsController < ApplicationController
  before_action :set_current_user
  
  include PublicActivity::StoreController 
  include EventsHelper
  
	def new
    @event = current_user.leading_events.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      EventHasGuest.create({guest_id: params[:event][:guests], event_id: @event.id}) 
      redirect_to event_path(@event.id)
    else
      redirect_to :back
      flash[:error] = @event.errors.full_messages.join('.\n ')
    end
  end

  def show
    if find_event_by_id and params[:can_visit].present?
      @event_has_guest = EventHasGuest.where(event_id: @event.id, guest: current_user)
      @event_has_guest.first.update_attributes(status: params[:can_visit] == "true" ? 1 : 0)
    end
  end

  def edit
    if find_event_by_id and @event.author != current_user
      flash[:error] = I18n.t('events.errors.no_edit')
      redirect_to events_path
    else
      @event.date = local_time_format(@event.date) if @event.date.present?
    end
  end

  def update
    @event = Event.find(params[:id])
    @event.update_attributes(event_params)
    redirect_to event_path(@event.id)
  end

  def index
  	if params[:search].present?    
      fix_params  
      @events = Event.connected_to_me
                .with_name(params[:name])
                .with_place(params[:place])
                .with_author(params[:author].split(" "))
                .created_at(local_time_convert(params[:creation_start_date]), local_time_convert(params[:creation_end_date]))   
                .order("created_at DESC").uniq

      date_range_check
      guests_check

      respond_to do |format|
        format.html
        format.js
      end
    else
      @events = Event.joins('LEFT JOIN event_has_guests ON events.id = event_has_guests.event_id')
        .where('event_has_guests.guest_id = ? OR events.author_id = ?', current_user.id, current_user.id)
        .uniq.order("created_at DESC")
    end
    @only_guest = !authored_any_event?(@events)
  end

  def destroy
    Event.find(params[:id]).destroy
    redirect_to :back
  end

  private
  def find_event_by_id
    begin
      @event = Event.find(params[:id])
    rescue
      redirect_to events_path, flash: { error: t('events.errors.not_found') } and false
    end
  end

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

  def fix_params
    params[:place] ||= ''
    params[:author] ||= User.all.pluck(:id).join(" ")      
    params[:creation_start_date] = local_time_format(Time.now - 1000.years) if !params[:creation_start_date].present?
    params[:creation_end_date] = local_time_format(Time.now + 1000.years) if !params[:creation_end_date].present?
  end

  def date_range_check
    if params[:event_start_date].present? || params[:event_end_date].present?
      @events = (
        begin
          @events.with_date(local_time_convert(params[:event_start_date]), local_time_convert(params[:event_end_date]))
        rescue
          begin
            @events.with_date(local_time_format(Time.now - 1000.years), local_time_convert(params[:event_end_date]))
          rescue
            @events.with_date(local_time_convert(params[:event_start_date]), local_time_format(Time.now + 1000.years))           
          end
        end
      )
    end
  end

  def guests_check
    if params[:invited].present?
      @events = @events.with_guests(params[:invited].flatten).order("created_at DESC").uniq
    end
  end
end
