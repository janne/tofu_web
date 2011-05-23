class ListsController < ApplicationController
  LIST_BASE = "todo"

  def index
    if @lists = todo_lists
      render :json => @lists
    else
      render :json => {:error => "Folder ~/Dropbox/#{LIST_BASE}/ can not be found"}, :code => 404
    end
  end

  def show
    list = params[:id] || 'todo'
    render :json => todo_items(list)
  end

  private

  def todo_lists
    @todo_lists = @dropbox_session.list(LIST_BASE) or return nil
    @todo_lists = @todo_lists.select{|file| !file["is_dir"] && file["path"] =~ /.txt$/}
    @todo_lists = @todo_lists.map{|file| File.basename(file["path"]).split(/\.txt/).first}
    @todo_lists = @todo_lists.select{|file| file !~ /^archive./ && file !~ /conflicted copy/}
  end

  def todo_items(list)
    @dropbox_session.download("#{LIST_BASE}/#{list}.txt").scan(/^\s*(?:\((\w)\)\s*)?(.*)$/).map do |prio, text|
      item = {:text => text}
      item[:prio] = prio if prio
      tags = text.scan(/@\S+/)
      item[:tags] = tags unless tags.empty?
      item
    end
  end
end
