class CollectionsController < ApplicationController
  def index
    @collections = Collection.for_property(params[:property_id])
  end
end
