class Category < ApplicationRecord
  has_many :projects, dependent: :nullify
end
