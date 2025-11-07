# config/initializers/kt_helpers.rb
#
# Initializer untuk meng-include helper KT secara global ke semua view.
# Tujuan: memastikan method seperti `kt_content_container` tersedia di semua template.
# Prinsip: KISS & YAGNI — hanya include modul yang dibutuhkan.

ActiveSupport.on_load(:action_view) do
  # Konten & layout: menyediakan `kt_content_container`, `kt_main_content`, `kt_page`, `kt_section`, dll.
  include KT::ContentHelper

  # Topbar user dropdown: menyediakan `kt_topbar_user` dan helper terkait.
  include KT::TopbarHelper
end