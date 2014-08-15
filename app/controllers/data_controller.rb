class DataController < ApplicationController
  def index
  	@items = Recipe.all
  end
end
