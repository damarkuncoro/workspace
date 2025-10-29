module ApplicationHelper

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
end

