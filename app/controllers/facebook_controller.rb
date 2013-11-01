class FacebookController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:subscription]
  protect_from_forgery with: :null_session

  def canvas 
    redirect_to "https://www.facebook.com/dialog/oauth?client_id=#{FB['key']}&redirect_uri=https://apps.facebook.com/inccountdowncent"
  end
end
