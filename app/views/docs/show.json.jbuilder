def add_image text
	text = text.to_s
	i = 0
	text.split(/ /).each do |word|
		if word[0..3] == '<img'
			word.replace('<br> <img class="inline-image" alt="" src="' + @doc.images[i].image.to_s + '"> <br>')
			Rails.logger.info @doc.images[i].image.to_s
			i += 1
		end
	end
end

unless @doc.images.empty?
	@doc.info = add_image(@doc.info).join(' ')
end
json.partial! 'doc', doc: @doc