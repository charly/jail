require_dependency "jail/application_controller"

module Jail
  class GithubsController < ApplicationController
    def index
      @githubs = Github.all
    end

    def show
      @github = Github.find(params[:name], params[:repo], params[:path])
    end

    def install
      @github = Github.find(params[:name], params[:repo])
      @github.install
      redirect_to root_path
    end

  end
end
