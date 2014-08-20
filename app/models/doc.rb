class Doc < ActiveRecord::Base
	has_attached_file :image, :styles => { :lrg => "700x700>", :med => "350x350>", :sml => "100x100>" }, :whiny => false, 
							:url  => "/images/docs/:id/:style/:basename.:extension",
							:path => ":rails_root/public/images/docs/:id/:style/:basename.:extension"
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
