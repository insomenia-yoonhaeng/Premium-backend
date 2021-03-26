class ProjectTutee < ApplicationRecord
  belongs_to :project
  belongs_to :tutee
end
