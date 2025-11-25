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

  # account_display_name
  # Tujuan: Menghasilkan nama tampilan untuk akun (person.name lalu email)
  # Input: Account atau nil
  # Output: String nama tampilan atau "-" jika tidak tersedia
  def account_display_name(account)
    account&.person&.name || account&.email || "-"
  end

  # issue_assignee_label
  # Tujuan: Mengembalikan label assignee utama (assigned_to) dalam format ramah
  # Input: Issue
  # Output: String nama tampilan atau "Tidak ada" jika kosong
  def issue_assignee_label(issue)
    name = account_display_name(issue&.assigned_to)
    name.present? && name != "-" ? name : "Tidak ada"
  end

  # issue_additional_assignees_label
  # Tujuan: Mengembalikan label untuk penanggung tambahan dari issue_assignments
  # Input: Issue
  # Output: Gabungan nama dipisah koma atau "Tidak ada" jika kosong
  def issue_additional_assignees_label(issue)
    assignments = issue.issue_assignments.includes(:account)
    names = assignments.map { |ia| account_display_name(ia.account) }.compact.reject { |n| n == "-" }
    names.any? ? names.join(", ") : "Tidak ada"
  end
end