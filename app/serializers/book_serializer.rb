class BookSerializer < Panko::Serializer
  attributes :title, :author, :content, :isbn, :publisher, :image

end