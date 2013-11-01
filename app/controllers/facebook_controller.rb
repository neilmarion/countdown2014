class FacebookController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:subscription]
  protect_from_forgery with: :null_session

  after_filter :allow_iframe

  def canvas 
    redirect_to "https://www.facebook.com/dialog/oauth?client_id=#{FB['key']}&redirect_uri=https://www.countdown2014.org"
  end

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end
end
