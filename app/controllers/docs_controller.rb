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
    if params[:imageData]
      decode_image
    end

    @doc = Doc.new(@up)

    if @doc.save
      render 'show', status: 201
    else
      render json: @doc.errors, status: :unprocessable_entity
      Rails.logger.info @doc.errors
    end

  end

  def update
    doc = Doc.find(params[:id])

    if params[:imageData]
      decode_image
    end

    doc.update_attributes(@up)

    head :no_content

  end

  def destroy
    doc = Doc.find(params[:id])
    doc.destroy
    head :no_content
  end

  private
    def doc_params
      @up = params.require(:doc).permit(:id, :title, :parent, :info, :image)
    end

    def decode_image
      @up = params.require(:doc).permit(:id, :title, :parent, :info, :image)
      # decode base64 string
      Rails.logger.info 'decoding now'
      decoded_data = Base64.decode64(params[:imageData]) # json parameter set in directive scope
      # create 'file' understandable by Paperclip
      @data = StringIO.new(decoded_data)
      @data.class_eval do
        attr_accessor :content_type, :original_filename
      end

      # set file properties
      @data.content_type = params[:imageContent] # json parameter set in directive scope
      @data.original_filename = params[:imagePath] # json parameter set in directive scope

      # update hash, I had to set @up to persist the hash so I can pass it for saving
      # since set_params returns a new hash everytime it is called (and must be used to explicitly list which params are allowed otherwise it throws an exception)
      @up[:image] = @data # user Icon is the model attribute that i defined as an attachment using paperclip generator
    end
end

