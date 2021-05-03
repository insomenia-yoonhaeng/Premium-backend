class BookSerializer < Panko::Serializer
  attributes :title, :author, :content, :isbn, :publisher, :image, :id, :chapters

  def chapters
    context[:chapters]
  end
end