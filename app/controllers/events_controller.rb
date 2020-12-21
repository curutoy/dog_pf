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
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
  end

  def destroy
  end
end
