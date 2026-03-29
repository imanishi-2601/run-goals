class Post < ApplicationRecord
  belongs_to :user
  belongs_to :community, optional: true

  validates :date, presence: true
  validates :distance, presence: true
  validates :time, presence: true

  def self.to_sec(hour, min, sec)
    hour_to_sec = hour * 60 * 60
    min_to_sec = min * 60
    result = hour_to_sec + min_to_sec + sec
  end

  def formatted_time
    h = time / 3600
    m = (time % 3600) / 60
    s = time % 60

    format("%02d:%02d:%02d", h, m, s)
  end

  def formatted_pace
    return "" if distance.blank? || distance.to_f <= 0 || time.blank?

    pace = (time / distance).to_i
    min = pace / 60
    sec = pace % 60

    format("%02d:%02d", min, sec)
  end
end
