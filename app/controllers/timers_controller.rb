class TimersController < ApplicationController
  def index
    @timers = Timer
  end

  def show
    @token = params[:token]
    @debug = !!params[:debug]

    respond_to do |format|
      format.html { render :show }
      format.json do
        timer = Timer.find_or_initialize_by(token: @token)
        timer.initialize! unless timer.persisted?

        render json: serialize_timer(timer)
      end
    end
  end

  def reset
    token = params[:token]

    raise "Invalid Token" if token.blank?

    timer = Timer.find_or_create_by(token: token)
    timer.update! start_at: Time.current

    render json: serialize_timer(timer)
  end

  private

  def serialize_timer(timer)
    {
      token: timer.token,
      start_at: timer.start_at,
    }
  end
end
