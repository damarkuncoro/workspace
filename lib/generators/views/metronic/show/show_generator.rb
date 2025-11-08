# frozen_string_literal: true

# Generator: Views::Metronic::Show::ShowGenerator
# Tujuan: Membuat view `show` untuk resource nested (misal issues/employees)
# Opsi: --namespace=protected (default)
# Catatan: Generator ini menghasilkan file view dan partial yang mengikuti struktur Metronic.

module Views
  module Metronic
      class ShowGenerator < Rails::Generators::Base
        source_root File.expand_path('templates', __dir__)

        argument :resource_path, type: :string, required: true, desc: 'Contoh: issues/employees'
        class_option :namespace, type: :string, default: 'protected', desc: 'Namespace untuk views, default: protected'

        # Menjalankan proses generate
        # - Mengatur konteks parent/resource
        # - Membuat file show.html.erb dan partials/_details.html.erb
        def create_show_views
          setup_context

          dest_dir = File.join('app', 'views', @namespace, @resource, @parent_plural)
          empty_directory dest_dir

          template 'show.html.erb.tt', File.join(dest_dir, 'index.html.erb'.sub('index', 'show'))

          partials_dir = File.join(dest_dir, 'partials')
          empty_directory partials_dir
          template '_details.html.erb.tt', File.join(partials_dir, '_details.html.erb')
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
