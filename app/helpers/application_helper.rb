module ApplicationHelper
  include Pagy::Frontend
  def full_page_title(title = nil)
    base_title = "CAKRAMEDIA"
    title.blank? ? base_title : "#{title} | #{base_title}"
  end

  def nav_active?(path)
    "active" if current_page?(path)
  end

  def status_badge(status)
    case status.downcase
    when "active", "completed", "success"
      "badge badge-success"
    when "pending", "in progress"
      "badge badge-warning"
    else
      "badge badge-secondary"
    end
  end

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
