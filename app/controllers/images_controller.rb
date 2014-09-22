class ImagesController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  before_action :find_doc

  def create
    @img = @doc.images.build(image: params[:file])
    if @img.save
    	render json: @img
    else
      render json: @img.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @doc.images.find(params[:id]).destroy!
    head :ok
  end

  private
	def find_doc
    @doc = Doc.find(params[:doc_id])
	end
end

