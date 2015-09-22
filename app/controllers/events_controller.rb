class EventsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]

  def index
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.events.new(event_params)
    @event.save
    redirect_to event_path(@event)
  end

  def show
    @event = Event.find(params[:id])
  end

  private

  def event_params
    params.require(:event).permit(:title)
  end

end