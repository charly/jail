require_dependency "jail/application_controller"

module Jail
  class CdnjsController < ApplicationController
    def index
      @cdnjs = Cdnjs.libs.map(&:name)
    end

    def show
      @cdnjs = Cdnjs.find(params[:name])
    end

    def install
      @cdnjs = Cdnjs.find(params[:name])
      @cdnjs.install(params["files"])

      redirect_to( "/jail/cdnjs/#{params[:name]}", :notice => "Installed!" )
    end
  end
end