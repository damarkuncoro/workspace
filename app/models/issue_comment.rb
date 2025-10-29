class IssueComment < ApplicationRecord
  belongs_to :issue
  belongs_to :account

  validates :content, presence: true
end
