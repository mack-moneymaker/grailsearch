class PricePoint < ApplicationRecord
  validates :query, :platform, :recorded_at, presence: true

  scope :for_query, ->(query) { where(query: query.downcase) }
  scope :recent, -> { order(recorded_at: :desc) }
  scope :last_30_days, -> { where("recorded_at > ?", 30.days.ago) }
end
