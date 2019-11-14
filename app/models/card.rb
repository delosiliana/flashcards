class Card < ApplicationRecord
  attr_reader :picture_remote_url
  belongs_to :user
  belongs_to :deck

  validates :original_text, :translated_text, :review_date, :deck_id, presence: true
  validate :check_text

  before_validation :set_review_date, only: :create

  has_attached_file :picture, styles: { original: '360x360>' }
  validates_attachment_content_type :picture,
                                    content_type: %r{\Aimage\/.*\z}

  DAYS_INTERVAL = [0.5, 1, 7, 14, 28, 30]
  MAX_MISTAKES = 3

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
    self.review_date = Date.current - 3.days
  end

  def check_try_count
    update(review_date: DateTime.current + DAYS_INTERVAL[self.try_count].days, try_count: try_count + 1 )
  end

  def check_false_count
    update(false_count: false_count + 1)
    if self.false_count == MAX_MISTAKES
      update(false_count: 0, try_count: 1, review_date: DateTime.current + 12.hours)
    end
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
