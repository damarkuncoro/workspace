# frozen_string_literal: true

# Generator: Views::Metronic::EditGenerator
# Tujuan: Membuat view `edit` untuk resource nested (misal issues/employees)
# Opsi: --namespace=protected (default)
# Catatan: Menghasilkan file view dan partial form mengikuti struktur Metronic.

module Views
  module Metronic
      class EditGenerator < Rails::Generators::Base
        source_root File.expand_path('templates', __dir__)

        argument :resource_path, type: :string, required: true, desc: 'Contoh: issues/employees'
        class_option :namespace, type: :string, default: 'protected', desc: 'Namespace untuk views, default: protected'

        # Menjalankan proses generate
        # - Mengatur konteks parent/resource
        # - Membuat file new.html.erb dan partials/_form.html.erb
        def create_new_views
          setup_context

          dest_dir = File.join('app', 'views', @namespace, @resource, @parent_plural)
          empty_directory dest_dir

          template 'edit.html.erb.tt', File.join(dest_dir, 'edit.html.erb')

          partials_dir = File.join(dest_dir, 'partials')
          empty_directory partials_dir
          template '_form.html.erb.tt', File.join(partials_dir, '_form.html.erb')
        end

        private

        # Menentukan konteks berdasarkan argumen resource_path
        # - @resource: resource utama (contoh: 'issues')
        # - @parent_plural: parent dalam bentuk jamak (contoh: 'employees')
        # - @parent_singular: bentuk tunggal parent (contoh: 'employee')
        # - @namespace: namespace views (contoh: 'protected')
        def setup_context
          parts = resource_path.to_s.split('/')
          @resource = parts[0]&.strip
          @parent_plural = parts[1]&.strip
          @parent_singular = @parent_plural.to_s.sub(/s\z/, '')
          @namespace = options['namespace'] || 'protected'

          unless @resource.present? && @parent_plural.present?
            say_status :error, 'Argumen harus berbentuk <resource>/<parent_plural>, contoh: issues/employees', :red
            raise ArgumentError, 'resource_path tidak valid'
          end
        end
      end
  end
end