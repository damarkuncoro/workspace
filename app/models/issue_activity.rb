class IssueActivity < ApplicationRecord
  belongs_to :issue
  belongs_to :account, optional: true

  def description
    case action
    when 'status_changed'
      "#{account&.person&.name || 'System'} changed status from #{old_value} to #{new_value}"
    when 'priority_changed'
      "#{account&.person&.name || 'System'} changed priority from #{old_value} to #{new_value}"
    when 'assigned'
      "#{account&.person&.name || 'System'} assigned the issue to #{new_value}"
    when 'comment_added'
      "#{account&.person&.name || 'System'} added a comment"
    when 'created'
      "#{account&.person&.name || 'System'} created the issue"
    else
      "#{account&.person&.name || 'System'} performed action: #{action}"
    end
  end
end
