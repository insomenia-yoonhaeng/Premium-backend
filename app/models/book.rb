class Book < ApplicationRecord
  included ImageUrl
  PERMIT_COLUMNS = [:title, :author, :content, :isbn, :publisher, :image]
end
