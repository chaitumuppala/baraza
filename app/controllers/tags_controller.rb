class TagsController < ApplicationController
  filter_resource_access

  def index
    @tags = Tag.where("name LIKE ?", "%#{params[:q]}%").collect(&:name).join(",")
  end
end