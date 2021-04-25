class Book < ApplicationRecord
  included ImageUrl
  PERMIT_COLUMNS = [:title, :author, :content, :isbn, :publisher, :image]

  # 책 없어지면, 챕터도 필요없는 것
  has_many :chapters, dependent: :destroy
end
