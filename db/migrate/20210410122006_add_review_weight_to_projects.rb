class AddReviewWeightToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :review_weight, :integer, default: 0
  end
end
