class DocsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @docs = if params[:keywords] 
                  Doc.where("title ilike ?", "%#{params[:keywords]}%")
               else
                 []
               end

    @items = Doc.all
  end

  def show
    @doc = Doc.find(params[:id])
  end

  def create
    @doc = Doc.new(doc_params)
    @doc.save
    render 'show', status: 201
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
    # Using a private method to encapsulate the permissible parameters is just a good pattern
    # since you'll be able to reuse the same permit list between create and update. Also, you
    # can specialize this method with per-user checking of permissible attributes.
    def doc_params
      params.require(:doc).permit(:title, :parent, :info, :image)
    end
end