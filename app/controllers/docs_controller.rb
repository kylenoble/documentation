class DocsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :load

  def load
    @doc = Doc.new
    @docs = if params[:keywords] 
              Doc.where("title ilike ?", "%#{params[:keywords]}%")
           else
             []
           end
  end

  def index
    @items = Doc.all
  end

  def show
    @doc = Doc.find(params[:id])
  end

  def create
    @doc = Doc.new(doc_params)

    if @doc.save
      render 'show', status: 201
    else
      render json: @doc.errors, status: :unprocessable_entity
      Rails.logger.info @doc.errors
    end
  end

  def update
    doc = Doc.find(params[:id])

    doc.update_attributes(doc_params)

    head :no_content
  end

  def destroy
    doc = Doc.find(params[:id])
    doc.destroy
    head :no_content
  end

  private
    def doc_params
      params.require(:doc).permit(:id, :title, :parent, :info)
    end
end

