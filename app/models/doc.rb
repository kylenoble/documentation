require 'elasticsearch/model'

class Doc < ActiveRecord::Base
	include Elasticsearch::Model
  	include Elasticsearch::Model::Callbacks

	has_many :images, :dependent => :destroy

	accepts_nested_attributes_for :images, :allow_destroy => true

	def self.search(query)
	  __elasticsearch__.search(
	    {
	      query: {
	        multi_match: {
	          query: query,
	          fields: ['title^10', 'info']
	        }
	      }
	    }
	  )
	end
end
Doc.import 