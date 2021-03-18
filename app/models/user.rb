class User < ApplicationRecord
  has_secure_password

  ransacker :status, formatter: proc {|v| statuses[v]}

  enum user_type: %i(tuty tutor)
  enum status: %i(default approving approved canceled)
end
