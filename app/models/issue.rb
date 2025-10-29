# app/models/issue.rb
class Issue < ApplicationRecord
  enum :status, { open: 0, in_progress: 1, completed: 2 , closed: 3}
  enum :priority, { low: 0, medium: 1, high: 2 }



  # Polymorphic association
  belongs_to :issueable, polymorphic: true, optional: true

  # Assigned account (single primary assignee)
  belongs_to :assigned_to, class_name: "Account", optional: true

  # Issue assignments (many-to-many with accounts)
  has_many :issue_assignments, dependent: :destroy
  has_many :assigned_accounts, through: :issue_assignments, source: :account

  has_many :issue_comments,   dependent: :destroy
  has_many :issue_activities, dependent: :destroy

  # Validations
  validates :title, presence: true

  # Scopes
  scope :open, -> { where(status: Issue.statuses[:open]) }
  scope :in_progress, -> { where(status: Issue.statuses[:in_progress]) }
  scope :completed, -> { where(status: Issue.statuses[:completed]) }
  scope :closed, -> { where(status: Issue.statuses[:closed]) }
  scope :assigned_to_account, ->(account_id) { where(assigned_to_id: account_id) }
  scope :high_priority, -> { where(priority: Issue.priorities[:high]) }

  # Callbacks (optional)
  before_create :default_status

  after_update :log_status_change, if: :saved_change_to_status?
  after_update :log_priority_change, if: :saved_change_to_priority?
  after_update :log_assignment_change, if: :saved_change_to_assigned_to_id?

  private

  def default_status
    self.status ||= Issue.statuses[:open]
  end

  def log_status_change
    issue_activities.create!(
      action: "status_changed",
      field_name: "status",
      old_value: status_before_last_save,
      new_value: status,
      account_id: assigned_to_id
    )
  end

  def log_priority_change
    issue_activities.create!(
      action: "priority_changed",
      field_name: "priority",
      old_value: priority_before_last_save,
      new_value: priority,
      account_id: assigned_to_id
    )
  end

  def log_assignment_change
    issue_activities.create!(
      action: "assignment_changed",
      field_name: "assigned_to_id",
      old_value: assigned_to_id_before_last_save,
      new_value: assigned_to_id
    )
  end


end
