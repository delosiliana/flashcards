class Deck < ActiveRecord::Base
  belongs_to :user
  validates :title, presence: true, uniqueness: { case_sensitive: false, scope: :user_id }
end
