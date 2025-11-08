# frozen_string_literal: true

# Generator: KT CRUD Views
# Tujuan: Membuat skeleton views CRUD (index, show, new, edit, _form, partials/_table)
#          yang konsisten dengan komponen KT (Metronic) dan pola layout proyek.
# Prinsip: SRP, DRY, KISS, YAGNI — generator fokus pada views saja.

require 'rails/generators/named_base'

# Kelas generator untuk membuat views CRUD dengan gaya KT/Metronic.
# Penggunaan:
#   bin/rails generate kt_crud_views ResourceName --namespace=protected
# Contoh:
#   bin/rails g kt_crud_views Account --namespace=protected
#   bin/rails g kt_crud_views customers --namespace=protected
#   bin/rails g kt_crud_views issues/issues --namespace=protected
class KtCrudViewsGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  class_option :namespace, type: :string, default: 'protected', desc: 'Namespace folder views (default: protected)'
  class_option :partials, type: :boolean, default: true, desc: 'Generate partials seperti _form dan partials/_table'

  # create_views: Titik masuk generator — memanggil semua pembuatan file views.
  def create_views
    template 'index.html.erb.tt', File.join(views_path, 'index.html.erb')
    template 'show.html.erb.tt',  File.join(views_path, 'show.html.erb')
    template 'new.html.erb.tt',   File.join(views_path, 'new.html.erb')
    template 'edit.html.erb.tt',  File.join(views_path, 'edit.html.erb')

    if options[:partials]
      template '_form.html.erb.tt', File.join(views_path, '_form.html.erb')
      empty_directory File.join(views_path, 'partials')
      template 'partials/_table.html.erb.tt', File.join(views_path, 'partials', '_table.html.erb')
    end
  end

  private

  # views_path: Menghasilkan path folder views berdasarkan namespace dan path resource.
  # - Mendukung nested name (misal: issues/issues) via file_path dari NamedBase.
  # - Contoh hasil: app/views/protected/accounts
  def views_path
    File.join('app/views', options[:namespace], file_path.pluralize)
  end

  # new_path_helper: Nama helper path untuk action new.
  # - Dibangun sebagai string method, dipakai dengan send(:method_name) di template.
  # - Contoh: "new_protected_account_path"
  def new_path_helper
    "new_#{options[:namespace]}_#{singular_table_name}_path"
  end

  # index_path_helper: Nama helper path untuk index listing.
  # - Contoh: "protected_accounts_path"
  def index_path_helper
    "#{options[:namespace]}_#{plural_table_name}_path"
  end

  # show_path_helper: Nama helper path untuk show.
  # - Contoh: "protected_account_path"
  def show_path_helper
    "#{options[:namespace]}_#{singular_table_name}_path"
  end

  # edit_path_helper: Nama helper path untuk edit.
  # - Contoh: "edit_protected_account_path"
  def edit_path_helper
    "edit_#{options[:namespace]}_#{singular_table_name}_path"
  end
end