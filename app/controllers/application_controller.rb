class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_dropbox_authorization

  private

  def check_dropbox_authorization
    return redirect_to(new_authorization_path) unless session[:dropbox_session]
    @dropbox_session = Dropbox::Session.deserialize(session[:dropbox_session])
    @dropbox_session.mode = :dropbox
    return redirect_to(new_authorization_path) unless @dropbox_session.authorized?
  end
end
