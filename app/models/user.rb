class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :identities, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, :trackable
	include ImageUrl
	include Imageable
  
	PERMIT_COLUMNS = [:image, :phone, :name, :type, :info, :status]
	
	#has_secure_password

  ransacker :status, formatter: proc {|v| statuses[v]}

  enum status: %i(default approving approved canceled)
end
