class DataController < ApplicationController
  def index
  	@items = Doc.all
  end
end
