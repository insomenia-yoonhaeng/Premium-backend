class Chapter < ApplicationRecord
  belongs_to :book

  has_many :options
  has_many :tutors, through: :options
end
