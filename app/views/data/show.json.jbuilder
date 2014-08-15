json.partial! 'recipe', recipe: @recipe

json.array! @items, :id, :name, :instructions