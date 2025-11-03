class Protected::Issues::IssuesController <  Protected::AdministratorController
  def index
    @issues = Issue.all.includes(:issueable, :assigned_to, :issue_assignments)
  end


  def customers
    @issues = Issue.includes(:issueable, :assigned_to, :issue_assignments).where(issueable_type: "Customer")
  end

  def employees
    @issues = Issue.includes(:issueable, :assigned_to, :issue_assignments).where(issueable_type: "Employee")
  end

  private

  def status_badge_class(status)
    case status
    when 'open'
      'bg-red-100 text-red-800'
    when 'in_progress'
      'bg-yellow-100 text-yellow-800'
    when 'completed'
      'bg-green-100 text-green-800'
    when 'closed'
      'bg-gray-100 text-gray-800'
    else
      'bg-gray-100 text-gray-800'
    end
  end

  def priority_badge_class(priority)
    case priority
    when 'high'
      'bg-red-100 text-red-800'
    when 'medium'
      'bg-yellow-100 text-yellow-800'
    when 'low'
      'bg-green-100 text-green-800'
    else
      'bg-blue-100 text-blue-800'
    end
  end
end
