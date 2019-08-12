class User < ApplicationRecord
  has_many :card

  validates :email, :password, presence: true
end
