class SearchResult < ApplicationRecord
  belongs_to :saved_search, optional: true

  validates :platform, :title, :url, presence: true

  PLATFORMS = %w[ebay vinted depop grailed vestiaire poshmark].freeze

  scope :by_platform, ->(platform) { where(platform: platform) }
  scope :recent, -> { order(listed_at: :desc) }
end
