# app/helpers/issues_helper.rb
module IssuesHelper
  # issue_status_badge_class
  # Tujuan: Mengembalikan kelas CSS untuk badge status issue
  # SRP: Memetakan nilai status ke kelas tailwind
  # Output: String kelas CSS
  def issue_status_badge_class(status)
    case status.to_s
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

  # issue_priority_badge_class
  # Tujuan: Mengembalikan kelas CSS untuk badge prioritas issue
  # SRP: Memetakan nilai prioritas ke kelas tailwind
  # Output: String kelas CSS
  def issue_priority_badge_class(priority)
    case priority.to_s
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

  # issue_status_label
  # Tujuan: Label status dalam bahasa Indonesia
  # Output: String label
  def issue_status_label(status)
    case status.to_s
    when 'open' then 'Terbuka'
    when 'in_progress' then 'Dalam Proses'
    when 'completed' then 'Selesai'
    when 'closed' then 'Ditutup'
    else status.to_s
    end
  end

  # issue_priority_label
  # Tujuan: Label prioritas dalam bahasa Indonesia
  # Output: String label
  def issue_priority_label(priority)
    case priority.to_s
    when 'low' then 'Rendah'
    when 'medium' then 'Sedang'
    when 'high' then 'Tinggi'
    else priority.to_s
    end
  end
end