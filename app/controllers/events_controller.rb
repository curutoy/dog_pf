class EventsController < ApplicationController
  before_action :authenticate_protector!, only: [:new, :create]
  before_action :right_protector, only: [:edit, :update, :destroy]

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
    @events = Event.search(@search_params).includes(protector: [image_attachment: :blob]).paginate(params).per(18).sorted
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

  def authenticate_protector!
    if user_signed_in?
      redirect_to root_path
      flash[:alert] = "保護活動家専用のページです"
    elsif protector_signed_in?
    else
      render template: "homes/index"
      flash[:alert] = "ログインまたはアカウント登録を行ってください"
    end
  end

  def right_protector
    @event = Event.find(params[:id])
    if user_signed_in? || @event.protector_id != current_protector.id
      redirect_to root_path
      flash[:alert] = "投稿者のみ閲覧できるページです。"
    end
  end
end
