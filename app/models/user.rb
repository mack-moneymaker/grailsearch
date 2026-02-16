class User < ApplicationRecord
  has_secure_password

  has_many :saved_searches, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true

  PLANS = %w[free pro].freeze

  after_initialize :set_default_plan

  def pro?
    plan == "pro"
  end

  def free?
    plan == "free"
  end

  def saved_search_limit
    pro? ? Float::INFINITY : 3
  end

  def can_create_saved_search?
    pro? || saved_searches.count < 3
  end

  private

  def set_default_plan
    self.plan ||= "free"
  end
end
