def add_image text, image
	text = text.to_s
	text.split(/ /).each do |word|
		if word[0..3] == '<img'
			word.replace('<br> <img class="inline-image" alt="" src="' + image + '"> <br>')
		end
	end
end

#@doc.info = add_image(@doc.info, @doc.image.to_s).join(' ')
json.partial! 'doc', doc: @doc