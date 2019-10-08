class Deck < ActiveRecord::Base
  belongs_to :user
  has_many :cards, dependent: :destroy

  validates :title, presence: true, uniqueness: { case_sensitive: false, scope: :user_id }
end
