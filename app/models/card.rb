class Card < ApplicationRecord
  attr_reader :picture_remote_url
  belongs_to :user
  belongs_to :deck

  validates :original_text, :translated_text, :review_date, :deck_id, presence: true
  validate :check_text

  #before_validation :set_review_date, only: :create
  before_validation :set_review_date, unless: :review_date?

  has_attached_file :picture, styles: { original: '360x360>' }
  validates_attachment_content_type :picture,
                                    content_type: %r{\Aimage\/.*\z}

  #DAYS_INTERVAL = [0.5, 1, 7, 14, 28, 30]
  #MAX_MISTAKES = 3

  scope :on_review_date, -> { order(review_date: :desc) }
  scope :sort_random, -> { order(Arel.sql('RANDOM()')) }
  scope :dated, -> { where('review_date <= ?', Date.today) }

  def check_original_text_answer(answer)
    original_text.casecmp?(answer)
  end

  def set_review_date
    #self.review_date = review_date_removal unless review_date
    self.review_date = Time.now + repetition_period
  end

  #def review_date_removal
  #  self.review_date = DateTime.current
  #end

  def repetition_period
    days_interval = { 0 => 0, 1 => 12.hours, 2 => 3.days, 3 => 1.week, 4 => 2.week }
    days_interval.fetch(try_count, 1.month)
  end

  def check_try_count
    if try_count <= 1
      update(review_date: DateTime.current + repetition_period[self.try_count].days, try_count: try_count + 1 )
    else
      self.review_date = DateTime.current + 30.days
    end
  end

  def check_mistake_count
    update(mistake_count: mistake_count + 1)
    if self.mistake_count == 3                              #<<<<<<<---------- где-то тут проблема
      update(mistake_count: 0, try_count: 1, review_date: DateTime.current + 12.hours)
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
