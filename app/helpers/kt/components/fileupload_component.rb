# app/helpers/kt/components/fileupload_component.rb
module KT::Components::FileuploadComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic file upload component
  def ui_fileupload(name:, accept: nil, multiple: false, max_size: nil, **options)
    upload_id = options[:id] || "fileupload-#{SecureRandom.hex(4)}"
    classes = build_fileupload_class(options.delete(:class))

    content_tag(:div, class: "kt-fileupload-wrapper", data: { "kt-fileupload": true }) do
      concat fileupload_input(name, accept, multiple, max_size, upload_id, classes)
      concat fileupload_dropzone(upload_id)
      concat fileupload_preview(upload_id)
    end
  end

  # ✅ SRP: Image upload with preview
  def ui_imageupload(name:, multiple: false, max_files: 1, aspect_ratio: nil, **options)
    upload_id = options[:id] || "imageupload-#{SecureRandom.hex(4)}"

    content_tag(:div, class: "kt-imageupload-wrapper", data: { "kt-imageupload": true, "kt-imageupload-max": max_files }) do
      concat imageupload_input(name, multiple, upload_id)
      concat imageupload_dropzone(upload_id, aspect_ratio)
      concat imageupload_gallery(upload_id)
    end
  end

  # ✅ SRP: Drag and drop file upload
  def ui_dragdrop_upload(name:, accept: nil, max_size: nil, **options)
    upload_id = options[:id] || "dragdrop-#{SecureRandom.hex(4)}"

    content_tag(:div, class: "kt-dragdrop-upload", data: { "kt-dragdrop": true }) do
      concat dragdrop_input(name, accept, max_size, upload_id)
      concat dragdrop_zone(upload_id)
      concat dragdrop_filelist(upload_id)
    end
  end

  private

  def fileupload_input(name, accept, multiple, max_size, upload_id, classes)
    file_field_tag(name, accept: accept, multiple: multiple, class: classes,
                   data: { "kt-fileupload-input": true, "kt-fileupload-target": upload_id, "kt-fileupload-max-size": max_size })
  end

  def fileupload_dropzone(upload_id)
    content_tag(:div, class: "kt-fileupload-dropzone", data: { "kt-fileupload-dropzone": upload_id }) do
      content_tag(:div, class: "text-center p-8 border-2 border-dashed border-muted-foreground/25 rounded-lg") do
        concat ui_icon(name: "upload-cloud", size: :lg, wrapper_class: "mx-auto mb-4 text-muted-foreground")
        concat content_tag(:p, "Drop files here or click to browse", class: "text-sm text-muted-foreground mb-2")
        concat content_tag(:p, "Supported formats: PDF, DOC, XLS up to 10MB", class: "text-xs text-muted-foreground")
      end
    end
  end

  def fileupload_preview(upload_id)
    content_tag(:div, class: "kt-fileupload-preview hidden", data: { "kt-fileupload-preview": upload_id }) do
      # Preview content will be populated by JavaScript
    end
  end

  def imageupload_input(name, multiple, upload_id)
    file_field_tag(name, accept: "image/*", multiple: multiple, class: "hidden",
                   data: { "kt-imageupload-input": true, "kt-imageupload-target": upload_id })
  end

  def imageupload_dropzone(upload_id, aspect_ratio)
    aspect_class = aspect_ratio ? "aspect-#{aspect_ratio}" : "aspect-square"

    content_tag(:div, class: "kt-imageupload-dropzone cursor-pointer", data: { "kt-imageupload-dropzone": upload_id }) do
      content_tag(:div, class: "#{aspect_class} border-2 border-dashed border-muted-foreground/25 rounded-lg flex items-center justify-center bg-muted/25 hover:bg-muted/50 transition-colors") do
        content_tag(:div, class: "text-center") do
          concat ui_icon(name: "image-plus", size: :lg, wrapper_class: "mx-auto mb-2 text-muted-foreground")
          concat content_tag(:p, "Click to upload image", class: "text-sm text-muted-foreground")
        end
      end
    end
  end

  def imageupload_gallery(upload_id)
    content_tag(:div, class: "kt-imageupload-gallery mt-4", data: { "kt-imageupload-gallery": upload_id }) do
      # Gallery will be populated by JavaScript
    end
  end

  def dragdrop_input(name, accept, max_size, upload_id)
    file_field_tag(name, accept: accept, multiple: true, class: "hidden",
                   data: { "kt-dragdrop-input": true, "kt-dragdrop-target": upload_id, "kt-dragdrop-max-size": max_size })
  end

  def dragdrop_zone(upload_id)
    content_tag(:div, class: "kt-dragdrop-zone border-2 border-dashed border-muted-foreground/25 rounded-lg p-12 text-center transition-colors",
                       data: { "kt-dragdrop-zone": upload_id }) do
      content_tag(:div, class: "space-y-4") do
        concat ui_icon(name: "upload", size: :xl, wrapper_class: "mx-auto text-muted-foreground")
        concat content_tag(:h3, "Drop files here", class: "text-lg font-medium")
        concat content_tag(:p, "or click to browse files", class: "text-muted-foreground")
        concat ui_button(text: "Browse Files", variant: :outline, class: "mt-4", data: { "kt-dragdrop-browse": upload_id })
      end
    end
  end

  def dragdrop_filelist(upload_id)
    content_tag(:div, class: "kt-dragdrop-filelist mt-4", data: { "kt-dragdrop-filelist": upload_id }) do
      # File list will be populated by JavaScript
    end
  end

  def build_fileupload_class(additional_class)
    classes = ["kt-fileupload-input"]
    classes << additional_class if additional_class
    classes.join(" ")
  end
end