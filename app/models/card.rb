class Card < ApplicationRecord
  attr_reader :picture_remote_url
  belongs_to :user

  validates :original_text, :translated_text, :review_date, presence: true
  validate :check_text

  before_validation :set_review_date, only: :create

  has_attached_file :picture, styles: { original: '360x360>' }
  validates_attachment_content_type :picture,
                                    content_type: %r{\Aimage\/.*\z}

  scope :on_review_date, -> { order(review_date: :desc) }
  scope :sort_random, -> { order(Arel.sql('RANDOM()')) }
  scope :dated, -> { where('review_date <= ?', Date.today) }

  def check_original_text_answer(answer)
    original_text.casecmp?(answer)
  end

  def reset_review_date!
    update!(review_date: review_date_removal)
  end

  def set_review_date
    self.review_date = review_date_removal unless review_date
  end

  def review_date_removal
    3.days.from_now.to_date
  end

  def check_text
    return errors.add(:translated_text, 'Должна быть разница между оригинальным и переведенным текстом') if original_text.casecmp?(translated_text)
  end

  def picture_remote_url=(url_value)
    if url_value.present?
      self.picture = URI.parse(url_value)
      @picture_remote_url = url_value
    end
  end
end
