class Protected::Issues::IssuesController <  Protected::AdministratorController
  

  def index
    @issues = Issue.all.includes(:issueable, :assigned_to, :issue_assignments)
  end

  
  def customers
    @issues = Issue.includes(:issueable, :assigned_to, :issue_assignments).where(issueable_type: 'Customer')
  end

  def employees
    @issues = Issue.includes(:issueable, :assigned_to, :issue_assignments).where(issueable_type: 'Employee')
  end

  private


end