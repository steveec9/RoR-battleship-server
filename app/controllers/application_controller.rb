class ApplicationController < ActionController::Base
  def error(msg = '')
    render :json => msg, :status => :bad_request
  end
end
