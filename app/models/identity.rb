class Identity < ApplicationRecord
  belongs_to :user, optional: true
  validates :uid, presence: true
  validates :provider, presence: true
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth, only_params)
    user_identity = find_or_create_by(uid: only_params ? auth.dig("user") : auth.uid , provider: only_params ? "Apple" : auth.provider)
  end
end

