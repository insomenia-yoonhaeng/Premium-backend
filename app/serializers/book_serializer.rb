class BookSerializer < Panko::Serializer
  attributes :id, :title, :author, :content, :isbn, :publisher, :image

  # 이런식으로 사용해도 됨. 참고하셈
  has_many :chapters, each_serializer: ChapterSerializer
end