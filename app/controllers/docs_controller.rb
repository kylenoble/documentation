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
    @doc = Doc.create!

    @img = @doc.images.build(image: params[:file])

    if @img.save
      render 'show', status: 201
    else
      render json: @doc.errors, status: :unprocessable_entity
      Rails.logger.info @doc.errors
    end
  end

  def update
    doc = Doc.find(params[:id])

    if params[:images][0][:imageData]
      decode_image
      doc.update_attributes(@up)
    else
      doc.update_attributes(params.require(:doc).permit(:id, :title, :parent, :info))
    end  

    head :no_content
  end

  def destroy
    doc = Doc.find(params[:id])
    doc.destroy
    head :no_content
  end

  private
    def doc_params
      @up = params.require(:doc).permit(:id, :title, :parent, :info, images: [:id, :image])
    end

    def decode_image
      @up = params.require(:doc).permit(:id, :title, :parent, :info, :images, images_attributes: [:id, :image])
      # decode base64 string
      attach_length = params[:images].length - 1
      for i in 0..attach_length
        Rails.logger.info 'decoding now'
        decoded_data = Base64.decode64(params[:images][i]["imageData"]) # json parameter set in directive scope
        # create 'file' understandable by Paperclip
        @data = StringIO.new(decoded_data)
        @data.class_eval do
          attr_accessor :content_type, :original_filename
        end

        # set file properties
        @data.content_type = params[:images][i]["imageContent"] # json parameter set in directive scope
        @data.original_filename = params[:images][i]["imagePath"] # json parameter set in directive scope
        # update hash, I had to set @up to persist the hash so I can pass it for saving
        # since set_params returns a new hash everytime it is called (and must be used to explicitly list which params are allowed otherwise it throws an exception)
        
        @up[:images] ||= []
        @image = @up[images_attributes: [:image]]
        @image = @data
        @up[:images].push(@image)
        Rails.logger.info @up
      end
    end
end

