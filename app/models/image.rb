class Image < ActiveRecord::Base
	belongs_to :doc

	validates :doc, :presence => true

	has_attached_file :image, :styles => { :lrg => "700x700>", :med => "350x350>", :sml => "100x100>" }, :whiny => false,
			      :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
      			  :url => "/system/:attachment/:id/:style/:filename" 
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end


