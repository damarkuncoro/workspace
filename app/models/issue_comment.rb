class IssueComment < ApplicationRecord
  # Asosiasi inti
  belongs_to :issue
  belongs_to :account

  # Validasi wajib
  validates :content, presence: true

  # Callback: catat aktivitas setelah komentar dibuat
  after_create_commit :log_comment_added

  private

  # log_comment_added
  # Tujuan: Mencatat aktivitas "comment_added" pada IssueActivity
  # SRP: Hanya bertanggung jawab mencatat aktivitas komentar baru
  # Output: Membuat baris IssueActivity dengan action 'comment_added'
  def log_comment_added
    issue.issue_activities.create!(
      action: "comment_added",
      account_id: account_id
    )
  end
end
