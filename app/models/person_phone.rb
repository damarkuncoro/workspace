class PersonPhone < ApplicationRecord
  belongs_to :person
  belongs_to :phone

  validates :person_id, presence: true
  validates :phone_id, presence: true
  validates :is_owner, inclusion: { in: [true, false] }
  validates :person_id, uniqueness: { scope: :phone_id }

  # Scopes
  scope :owners, -> { where(is_owner: true) }
  scope :shared, -> { where(is_owner: false) }

  # Methods
  def relationship_type
    is_owner? ? 'Owner' : 'Shared'
  end
end
