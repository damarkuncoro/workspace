class IssueAssignment < ApplicationRecord
  belongs_to :issue
  belongs_to :account

  validates :issue_id, uniqueness: { scope: :account_id }
end
