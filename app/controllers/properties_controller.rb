class PropertiesController < ApplicationController
  def index

    @properties = Property.search(params[:q])

    respond_to do |format|
      format.json
    end
  end
end
