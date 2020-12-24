class EventsController < ApplicationController
  before_action :authenticate_any!

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.protector_id = current_protector.id
    if @event.save
      redirect_to events_path
    else
      render :new
    end
  end

  def index
    @search_params = events_search_params
    @events = Event.search(@search_params).includes(:protector).paginate(params).per(18).order('id DESC')
  end

  def show
    @event = Event.find(params[:id])
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event }
        format.js { @status = "success" }
      else
        format.html { render 'events/show' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
        format.js { @status = "fail" }
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path
  end

  private

  def event_params
    params.require(:event).permit(:protector_id, :due_on, :start_at, :finish_at,
                                  :prefecture, :address, :latitude, :longitude, :content)
  end

  def events_search_params
    params.fetch(:search, {}).permit(:prefecture, :due_on_from, :due_on_to)
  end
end
