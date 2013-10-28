class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def all
    user = User.from_omniauth(request.env["omniauth.auth"])

    if user.persisted?
      flash.notice = "Thanks for sharing! Wait for a while until the photo is uploaded to your Facebook profile"
      sign_in_and_redirect user
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_session_path
    end
  end

  alias_method :facebook, :all

end
