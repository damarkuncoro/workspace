# frozen_string_literal: true

# Generator: views:metronic:index
# Tujuan: Menghasilkan view index Metronic untuk resource nested seperti
#         `issues/customers` di dalam namespace (misal `protected`).
# Prinsip: SRP (generator fokus buat index dan partial tabel), DRY/KISS/YAGNI,
#          SOLID (class kecil dengan satu tanggung jawab), Composition over Inheritance.

require 'rails/generators'
require 'active_support/inflector'

module Views
  module Metronic
    # Generator utama untuk perintah `rails g views:metronic:index <resource_path> --namespace=protected`
    class IndexGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      argument :resource_path, type: :string, required: true,
                desc: "Path resource relative ke views, contoh: 'issues/customers'"

      class_option :namespace, type: :string, default: nil,
                   desc: "Namespace untuk views, contoh: 'protected'"

      # create_index_view
      # Tanggung jawab: Membuat file index.html.erb di lokasi yang tepat.
      def create_index_view
        setup_context
        dest_dir = destination_dir
        empty_directory dest_dir

        template 'index.html.erb.tt', File.join(dest_dir, 'index.html.erb')
      end

      # create_partials
      # Tanggung jawab: Membuat partial tabel untuk daftar records.
      def create_partials
        setup_context
        dest_dir = File.join(destination_dir, 'partials')
        empty_directory dest_dir

        template '_table.html.erb.tt', File.join(dest_dir, '_table.html.erb')
      end

      private

      # destination_dir
      # Tanggung jawab: Menghitung direktori tujuan berdasarkan namespace dan resource_path.
      def destination_dir
        ns = options[:namespace].to_s.strip
        base = File.join('app', 'views')
        return File.join(base, ns, resource_path) if ns.present?

        File.join(base, resource_path)
      end

      # setup_context
      # Tanggung jawab: Menentukan variabel konteks untuk template (namespace, parent_singular/plural).
      def setup_context
        @namespace = options[:namespace].to_s.strip.presence || nil
        segments = resource_path.to_s.split('/')
        @resource_base = segments.first # contoh: 'issues'
        @parent_plural = segments.second || segments.last # contoh: 'customers' / 'employees'
        @parent_singular = @parent_plural.to_s.singularize # 'customer' / 'employee'
      end
    end
  end
end