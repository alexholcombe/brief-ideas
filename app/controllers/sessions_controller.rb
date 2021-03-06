class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.from_omniauth(env["omniauth.auth"])

    # Get the user's name from ORCID API
    OrcidWorker.perform_async(user.uid)

    session[:user_id] = user.id
    redirect_to root_url, :notice => "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end

protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
