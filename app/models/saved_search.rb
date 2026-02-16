class SavedSearch < ApplicationRecord
  belongs_to :user
  has_many :search_results, dependent: :destroy

  validates :query, presence: true

  scope :active, -> { where(active: true) }
  scope :due_for_check, -> { active.where("last_checked_at IS NULL OR last_checked_at < ?", 1.hour.ago) }

  after_initialize :set_defaults

  def search_params
    {
      query: query,
      brand: brand,
      size: size,
      color: color,
      min_price: min_price,
      max_price: max_price,
      category: category
    }.compact_blank
  end

  def mark_checked!
    update!(last_checked_at: Time.current)
  end

  private

  def set_defaults
    self.active = true if active.nil?
  end
end
