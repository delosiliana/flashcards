class Card < ApplicationRecord
  attr_reader :picture_remote_url
  belongs_to :user
  belongs_to :deck

  validates :original_text, :translated_text, :review_date, :deck_id, presence: true
  validate :check_text

  before_validation :set_review_date, unless: :review_date?

  has_attached_file :picture, styles: { original: '360x360>' }
  validates_attachment_content_type :picture,
                                    content_type: %r{\Aimage\/.*\z}

  scope :on_review_date, -> { order(review_date: :desc) }
  scope :sort_random, -> { order(Arel.sql('RANDOM()')) }
  scope :dated, -> { where('review_date <= ?', Time.now) }

  def check_original_text_answer(answer)
    original_text.casecmp?(answer)
  end

  def set_review_date
    self.review_date = new_review_date
  end

  def new_review_date
    Time.now + repetition_period
  end

  def repetition_period
    days_interval = { 0 => 0, 1 => 12.hours, 2 => 3.days, 3 => 1.week, 4 => 2.week }
    days_interval.fetch(try_count, 1.month)
  end

  def rise_try_count
    update(try_count: try_count + 1, mistake_count: 0, review_date: new_review_date)
  end

  def process_mistake
    update(mistake_count: mistake_count + 1)
    update(try_count: 0, mistake_count: 0) if mistake_count == 3
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
