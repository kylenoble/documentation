class DocsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @docs = if params[:keywords] 
                  docs.where('title or parent or info ilike ?',"%#{params[:keywords]}%")
               else
                 []
               end

    @items = Doc.all
  end

  def show
    @doc = Doc.find(params[:id])
  end

  def create
    @doc = Doc.new(params.require(:doc).permit(:title, :parent, :info))
    @doc.save
    render 'show', status: 201
  end

  def update
    doc = Doc.find(params[:id])
    doc.update_attributes(params.require(:doc).permit(:title, :parent, :info))
    head :no_content
  end

  def destroy
    doc = Doc.find(params[:id])
    doc.destroy
    head :no_content
  end
end