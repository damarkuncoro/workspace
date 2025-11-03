class CustomerPhone < ApplicationRecord
  belongs_to :customer
  has_many :phone_activities, dependent: :destroy

  validates :phone_number, presence: true, uniqueness: { scope: :customer_id }
  validates :phone_type, presence: true, inclusion: { in: %w[mobile home work fax] }
  validates :is_primary, inclusion: { in: [true, false] }

  # Scopes
  scope :primary, -> { where(is_primary: true) }
  scope :by_type, ->(type) { where(phone_type: type) }

  # Callbacks
  before_save :ensure_only_one_primary

  # Methods
  def formatted_number
    # Basic formatting - can be enhanced based on country codes
    case phone_number.length
    when 10
      "#{phone_number[0..2]}-#{phone_number[3..5]}-#{phone_number[6..9]}"
    when 11
      "#{phone_number[0..2]}-#{phone_number[3..6]}-#{phone_number[7..10]}"
    when 12
      "#{phone_number[0..3]}-#{phone_number[4..7]}-#{phone_number[8..11]}"
    else
      phone_number
    end
  end

  def phone_type_label
    case phone_type
    when 'mobile' then 'Mobile'
    when 'home' then 'Home'
    when 'work' then 'Work'
    when 'fax' then 'Fax'
    else phone_type.titleize
    end
  end

  def recent_activities(limit = 10)
    phone_activities.recent.limit(limit)
  end

  def call_history
    phone_activities.calls.recent
  end

  def message_history
    phone_activities.messages.recent
  end

  private

  def ensure_only_one_primary
    if is_primary? && is_primary_changed?
      customer.customer_phones.where.not(id: id).update_all(is_primary: false)
    end
  end
end