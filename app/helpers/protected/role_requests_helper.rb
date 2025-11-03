module Protected::RoleRequestsHelper
  def status_badge_class(status)
    case status
    when 'pending'
      'bg-yellow-100 text-yellow-800'
    when 'approved'
      'bg-green-100 text-green-800'
    when 'rejected'
      'bg-red-100 text-red-800'
    when 'cancelled'
      'bg-gray-100 text-gray-800'
    else
      'bg-gray-100 text-gray-800'
    end
  end
end
