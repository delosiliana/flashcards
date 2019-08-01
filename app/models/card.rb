class Card < ApplicationRecord
  validates :original_text, :translated_text, :review_date, presence: true

  before_validation :set_review_date, only: :create

  scope :on_review_date, -> { order(review_date: :desc) }

  private

  def set_review_date
    self.review_date = Time.now + 3.days
  end
end
