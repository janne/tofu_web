class ItemsController < ApplicationController
  def index
    @items = @dropbox_session.download("todo/stugan.txt").split("\n")
  end
end
