# app/helpers/kt/components/modal_component.rb
module KT::Components::ModalComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic modal component
  def ui_modal(title:, content:, footer: nil, size: :md, **options)
    modal_id = options.delete(:id) || "modal-#{SecureRandom.hex(4)}"
    classes = build_modal_class
    data_attrs = { "kt-modal": true }

    content_tag(:div, class: classes, id: modal_id, data: data_attrs, **options) do
      concat modal_backdrop
      concat modal_dialog(size) do
        concat modal_header(title)
        concat modal_body(content)
        concat modal_footer(footer) if footer
      end
    end
  end

  # ✅ SRP: Confirmation modal
  def ui_modal_confirm(title:, message:, confirm_text: "Confirm", cancel_text: "Cancel", **options)
    footer = content_tag(:div, class: "flex justify-end gap-3") do
      concat ui_button(text: cancel_text, variant: :outline, "data-kt-modal-dismiss": true)
      concat ui_button(text: confirm_text, variant: :primary, "data-kt-modal-confirm": true)
    end

    ui_modal(title: title, content: message, footer: footer, **options)
  end

  # ✅ SRP: Modal trigger button
  def ui_modal_trigger(text:, modal_id:, **options)
    ui_button(text: text, "data-kt-modal-toggle": modal_id, **options)
  end

  private

  def modal_backdrop
    content_tag(:div, "", class: "kt-modal-backdrop", "data-kt-modal-backdrop": true)
  end

  def modal_dialog(size)
    size_class = case size
                 when :sm then "max-w-md"
                 when :lg then "max-w-2xl"
                 when :xl then "max-w-4xl"
                 when :full then "max-w-full mx-4"
                 else "max-w-lg"
                 end

    content_tag(:div, class: "kt-modal-dialog #{size_class}", "data-kt-modal-dialog": true) do
      content_tag(:div, class: "kt-modal-content bg-background border border-border rounded-lg shadow-xl") do
        yield
      end
    end
  end

  def modal_header(title)
    content_tag(:div, class: "kt-modal-header flex items-center justify-between p-6 border-b border-border") do
      concat content_tag(:h3, title, class: "text-lg font-semibold")
      concat modal_close_button
    end
  end

  def modal_body(content)
    content_tag(:div, class: "kt-modal-body p-6") do
      content
    end
  end

  def modal_footer(footer)
    content_tag(:div, class: "kt-modal-footer flex items-center justify-end gap-3 p-6 border-t border-border") do
      footer
    end
  end

  def modal_close_button
    content_tag(:button, class: "kt-modal-close", type: "button", "data-kt-modal-dismiss": true, "aria-label": "Close modal") do
      ui_icon(name: "x", size: :lg)
    end
  end

  def build_modal_class
    "kt-modal fixed inset-0 z-50 hidden items-center justify-center"
  end
end