class AuthorizationsController < ApplicationController
  skip_before_filter :check_dropbox_authorization

  def show
    if params[:oauth_token] then
      dropbox_session = Dropbox::Session.deserialize(session[:dropbox_session])
      dropbox_session.authorize(params)
      session[:dropbox_session] = dropbox_session.serialize
      redirect_to root_path
    else
      config = YAML.load_file("config/dropbox.yml")
      dropbox_session = Dropbox::Session.new(config['key'], config['secret'])
      dropbox_session.mode = :dropbox
      session[:dropbox_session] = dropbox_session.serialize
      redirect_to dropbox_session.authorize_url(:oauth_callback => authorization_url)
    end
  end
end
