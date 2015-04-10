json.array!(@books) do |book|
  json.extract! book, :id, :title, :description, :content, :person_id
  json.url book_url(book, format: :json)
end
