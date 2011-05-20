class AuthorizationsController < ApplicationController
  skip_before_filter :check_dropbox_authorization

  def new
    if params[:oauth_token] then
      dropbox_session = Dropbox::Session.deserialize(session[:dropbox_session])
      dropbox_session.authorize(params)
      session[:dropbox_session] = dropbox_session.serialize
      redirect_to items_path
    else
      config = YAML.load_file("config/dropbox.yml")
      dropbox_session = Dropbox::Session.new(config['key'], config['secret'])
      session[:dropbox_session] = dropbox_session.serialize
      redirect_to dropbox_session.authorize_url(:oauth_callback => new_authorizations_url)
    end
  end
end
