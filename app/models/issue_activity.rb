class IssueActivity < ApplicationRecord
  # Asosiasi inti
  belongs_to :issue
  belongs_to :account, optional: true

  # description
  # Tujuan: Menghasilkan deskripsi aktivitas yang ringkas untuk ditampilkan di timeline
  # SRP: Hanya bertanggung jawab mengubah kode aksi menjadi teks deskriptif
  # Output: String bahasa Indonesia yang menjelaskan aktivitas
  def description
    actor = account&.person&.name || account&.email || "Sistem"

    case action
    when "status_changed"
      "#{actor} mengubah status dari #{old_value} menjadi #{new_value}"
    when "priority_changed"
      "#{actor} mengubah prioritas dari #{old_value} menjadi #{new_value}"
    when "assignment_changed", "assigned"
      "#{actor} mengubah penanggung utama menjadi ID: #{new_value}"
    when "comment_added"
      "#{actor} menambahkan komentar"
    when "created"
      "#{actor} membuat issue"
    else
      "#{actor} melakukan aksi: #{action}"
    end
  end
end
