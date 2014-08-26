x = 0 
items_length = @items.length
parent_values = []
while x < items_length
	unless parent_values.include? @items[x]["parent"]
		parent_values.push(@items[x]["parent"])
	end
	x += 1
end

new_items = []




for i in 0..items_length - 1
	for z in 0..parent_values.length - 1
		new_items[z] ||= {}
		if @items[i]["parent"] == parent_values[z]
			new_items[z]["parent"] = @items[i]["parent"]
			new_items[z]["details"] ||= []
			new_items[z]["details"][i] ||= {}
			new_items[z]["details"][i]["id"] = @items[i]["id"]
			new_items[z]["details"][i]["title"] = @items[i]["title"]
			new_items[z]["details"][i]["info"] = @items[i]["info"]
			new_items[z]["details"].compact!
		end
		z += 1
	end
	i += 1
end

json.docs(new_items) 
json.array(@items)
