# frozen_string_literal: true

# KT::Form::FieldHelper
# Tanggung jawab:
# - Menyediakan helper untuk membuat field form dengan styling KT (Keenthemes/Metronic)
# - Mendukung berbagai tipe field (text, select, textarea, date, dll.)
# - Konsisten dengan desain Metronic dan mendukung error states
# - Mengurangi boilerplate HTML di view
#
# Catatan:
# - Semua metode defensif terhadap nilai nil
# - Menggunakan content_tag untuk safe HTML generation
# - Mendukung custom classes dan attributes
module KT
  module Form
    module FieldHelper
      # Membuat field text input dengan label dan error handling
      # Param:
      # - form: [FormBuilder] form builder object
      # - method: [Symbol] method name untuk field
      # - label: [String] label text (opsional, default dari method)
      # - options: [Hash] opsi tambahan untuk field
      # Return: [String] HTML field
      def kt_text_field(form, method, label: nil, **options)
        field_wrapper(form, method, label) do
          form.text_field method, field_options(options)
        end
      end

      # Membuat field email input
      # Param: sama dengan kt_text_field
      # Return: [String] HTML field
      def kt_email_field(form, method, label: nil, **options)
        field_wrapper(form, method, label) do
          form.email_field method, field_options(options)
        end
      end

      # Membuat field password input
      # Param: sama dengan kt_text_field
      # Return: [String] HTML field
      def kt_password_field(form, method, label: nil, **options)
        field_wrapper(form, method, label) do
          form.password_field method, field_options(options)
        end
      end

      # Membuat field textarea
      # Param:
      # - form: [FormBuilder] form builder object
      # - method: [Symbol] method name untuk field
      # - label: [String] label text (opsional)
      # - rows: [Integer] jumlah baris (default: 3)
      # - options: [Hash] opsi tambahan
      # Return: [String] HTML field
      def kt_text_area(form, method, label: nil, rows: 3, **options)
        field_wrapper(form, method, label) do
          form.text_area method, field_options(options.merge(rows: rows))
        end
      end

      # Membuat field select
      # Param:
      # - form: [FormBuilder] form builder object
      # - method: [Symbol] method name untuk field
      # - collection: [Array] collection untuk options
      # - label: [String] label text (opsional)
      # - include_blank: [Boolean|String] include blank option
      # - options: [Hash] opsi tambahan
      # Return: [String] HTML field
      def kt_select_field(form, method, collection, label: nil, include_blank: false, **options)
        field_wrapper(form, method, label) do
          form.select method, collection, { include_blank: include_blank }, field_options(options)
        end
      end

      # Membuat field date
      # Param: sama dengan kt_text_field
      # Return: [String] HTML field
      def kt_date_field(form, method, label: nil, **options)
        field_wrapper(form, method, label) do
          form.date_field method, field_options(options)
        end
      end

      # Membuat field number
      # Param: sama dengan kt_text_field
      # Return: [String] HTML field
      def kt_number_field(form, method, label: nil, **options)
        field_wrapper(form, method, label) do
          form.number_field method, field_options(options)
        end
      end

      # Membuat field checkbox
      # Param:
      # - form: [FormBuilder] form builder object
      # - method: [Symbol] method name untuk field
      # - label: [String] label text
      # - options: [Hash] opsi tambahan
      # Return: [String] HTML field
      def kt_check_box(form, method, label:, **options)
        content_tag(:div, class: 'flex items-center') do
          form.check_box(method, field_options(options)) +
          content_tag(:label, label, class: 'ml-2 block text-sm text-gray-900', for: form.field_id(method))
        end
      end

      # Membuat field radio button
      # Param:
      # - form: [FormBuilder] form builder object
      # - method: [Symbol] method name untuk field
      # - value: [String] value untuk radio button
      # - label: [String] label text
      # - options: [Hash] opsi tambahan
      # Return: [String] HTML field
      def kt_radio_button(form, method, value, label:, **options)
        content_tag(:div, class: 'flex items-center') do
          form.radio_button(method, value, field_options(options)) +
          content_tag(:label, label, class: 'ml-2 block text-sm text-gray-900', for: form.field_id(method, value))
        end
      end

      # Membuat field read-only (display only)
      # Param:
      # - label: [String] label text
      # - value: [String] nilai yang ditampilkan
      # - options: [Hash] opsi tambahan untuk styling
      # Return: [String] HTML field read-only
      def kt_display_field(label, value, **options)
        classes = "block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm bg-gray-50 text-gray-900 cursor-not-allowed"
        classes += " #{options[:class]}" if options[:class]

        content_tag(:div) do
          content_tag(:label, label, class: "block text-sm font-medium text-gray-700") +
          content_tag(:div, class: "mt-1") do
            content_tag(:input, type: "text", value: value, class: classes, readonly: true, **options.except(:class))
          end
        end
      end

      # Membuat field dengan file upload
      # Param: sama dengan kt_text_field
      # Return: [String] HTML field
      def kt_file_field(form, method, label: nil, **options)
        field_wrapper(form, method, label) do
          form.file_field method, field_options(options)
        end
      end

      private

      # Wrapper untuk field dengan label dan error handling
      def field_wrapper(form, method, label_text = nil)
        label_text ||= method.to_s.humanize

        content_tag(:div) do
          # Label
          content_tag(:label, label_text, class: "block text-sm font-medium text-gray-700", for: form.field_id(method)) +

          # Field container
          content_tag(:div, class: "mt-1") do
            # Field content
            content = yield

            # Error message
            error_message = form.object.errors[method].first if form.object&.errors&.include?(method)
            if error_message.present?
              content += content_tag(:p, error_message, class: "mt-2 text-sm text-red-600")
            end

            content
          end
        end
      end

      # Default options untuk field
      def field_options(options)
        default_classes = "block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"

        # Add error styling if field has errors
        if options[:error].present?
          default_classes += " border-red-300 text-red-900 placeholder-red-300 focus:ring-red-500 focus:border-red-500"
        end

        # Merge with custom classes
        if options[:class].present?
          default_classes += " #{options[:class]}"
        end

        options.merge(class: default_classes).except(:error)
      end
    end
  end
end