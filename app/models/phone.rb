class Phone < ApplicationRecord
  has_many :person_phones, dependent: :destroy
  has_many :people, through: :person_phones

  # Through relationships for customers and employees
  has_many :customers, through: :people
  has_many :employees, through: :people

  # Phone activities
  has_many :phone_activities, dependent: :destroy

  validates :phone_number, presence: true, uniqueness: true
  validates :phone_type, presence: true, inclusion: { in: %w[mobile home work fax] }

  # Scopes
  scope :primary, -> { where(is_primary: true) }
  scope :by_type, ->(type) { where(phone_type: type) }

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

  def owners
    people.where(person_phones: { is_owner: true })
  end

  def shared_users
    people.where(person_phones: { is_owner: false })
  end
end
