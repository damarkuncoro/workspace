# app/helpers/kt/components/filemanager_component.rb
module KT::Components::FilemanagerComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic file manager component
  def ui_file_manager(files: [], current_path: "/", **options)
    manager_id = options[:id] || "filemanager-#{SecureRandom.hex(4)}"
    classes = build_file_manager_class(options.delete(:class))

    content_tag(:div, class: classes, **options) do
      concat file_manager_toolbar(manager_id, current_path)
      concat file_manager_breadcrumbs(current_path, manager_id)
      concat file_manager_view(files, manager_id)
    end
  end

  # ✅ SRP: Gallery component
  def ui_gallery(images: [], layout: :grid, **options)
    gallery_id = options[:id] || "gallery-#{SecureRandom.hex(4)}"
    classes = build_gallery_class(layout, options.delete(:class))

    content_tag(:div, class: classes, **options) do
      concat gallery_toolbar(gallery_id) if options[:toolbar]
      concat gallery_grid(images, gallery_id, layout)
      concat gallery_lightbox(gallery_id)
    end
  end

  private

  def file_manager_toolbar(manager_id, current_path)
    content_tag(:div, class: "kt-file-manager-toolbar flex items-center justify-between p-4 border-b border-border") do
      concat file_manager_actions(manager_id)
      concat file_manager_view_toggle(manager_id)
    end
  end

  def file_manager_actions(manager_id)
    content_tag(:div, class: "kt-file-manager-actions flex items-center gap-2") do
      concat ui_button(text: "Upload", icon: "upload", variant: :outline, size: :sm, data: { "kt-file-upload": manager_id })
      concat ui_button(text: "New Folder", icon: "folder-plus", variant: :outline, size: :sm, data: { "kt-file-new-folder": manager_id })
    end
  end

  def file_manager_view_toggle(manager_id)
    content_tag(:div, class: "kt-file-manager-view-toggle flex border border-border rounded") do
      concat ui_button(icon: "list", variant: :ghost, size: :sm, class: "rounded-r-none", data: { "kt-file-view": "list" })
      concat ui_button(icon: "grid", variant: :ghost, size: :sm, class: "rounded-l-none", data: { "kt-file-view": "grid" })
    end
  end

  def file_manager_breadcrumbs(current_path, manager_id)
    path_parts = current_path.split('/').reject(&:empty?)
    content_tag(:div, class: "kt-file-manager-breadcrumbs flex items-center gap-2 p-4 border-b border-border bg-muted/25") do
      concat ui_button(icon: "home", variant: :ghost, size: :sm, data: { "kt-file-navigate": "/" })
      concat content_tag(:span, "/", class: "text-muted-foreground")
      safe_join(path_parts.each_with_index.map { |part, index|
        concat content_tag(:span, "/", class: "text-muted-foreground mx-1") if index > 0
        concat ui_button(text: part, variant: :ghost, size: :sm, class: "text-primary", data: { "kt-file-navigate": path_parts[0..index].join('/') })
      })
    end
  end

  def file_manager_view(files, manager_id)
    content_tag(:div, class: "kt-file-manager-view", data: { "kt-file-manager-view": manager_id }) do
      # Default to grid view
      file_manager_grid_view(files, manager_id)
    end
  end

  def file_manager_grid_view(files, manager_id)
    content_tag(:div, class: "kt-file-manager-grid grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4 p-4") do
      safe_join(files.map { |file| file_manager_file_item(file, manager_id) })
    end
  end

  def file_manager_file_item(file, manager_id)
    content_tag(:div, class: "kt-file-manager-item group relative border border-border rounded-lg p-4 hover:border-primary hover:shadow-md transition-all cursor-pointer",
                data: { "kt-file-item": file[:id] }) do
      concat file_manager_file_icon(file)
      concat file_manager_file_info(file)
      concat file_manager_file_actions(file, manager_id)
    end
  end

  def file_manager_file_icon(file)
    icon_name = case file[:type]
                when :folder then "folder"
                when :image then "image"
                when :document then "file-text"
                when :video then "video"
                when :audio then "music"
                else "file"
                end

    content_tag(:div, class: "kt-file-icon flex items-center justify-center h-12 w-12 mx-auto mb-2") do
      ui_icon(name: icon_name, size: :lg, wrapper_class: file[:type] == :folder ? "text-blue-500" : "text-muted-foreground")
    end
  end

  def file_manager_file_info(file)
    content_tag(:div, class: "kt-file-info text-center") do
      concat content_tag(:div, file[:name], class: "kt-file-name text-sm font-medium truncate")
      concat content_tag(:div, file[:size], class: "kt-file-size text-xs text-muted-foreground") if file[:size]
    end
  end

  def file_manager_file_actions(file, manager_id)
    content_tag(:div, class: "kt-file-actions absolute top-2 right-2 opacity-0 group-hover:opacity-100 transition-opacity") do
      ui_context_menu(
        trigger: ui_icon_button(icon: "more-vertical", size: :xs, variant: :ghost),
        items: [
          { text: "Download", icon: "download", href: "#", data: { "kt-file-download": file[:id] } },
          { text: "Rename", icon: "edit", href: "#", data: { "kt-file-rename": file[:id] } },
          { text: "Move", icon: "move", href: "#", data: { "kt-file-move": file[:id] } },
          { divider: true },
          { text: "Delete", icon: "trash", href: "#", data: { "kt-file-delete": file[:id] } }
        ]
      )
    end
  end

  def gallery_toolbar(gallery_id)
    content_tag(:div, class: "kt-gallery-toolbar flex items-center justify-between p-4 border-b border-border") do
      concat content_tag(:div, class: "kt-gallery-info text-sm text-muted-foreground") do
        "12 photos"
      end
      concat ui_button(text: "Upload", icon: "upload", variant: :outline, size: :sm, data: { "kt-gallery-upload": gallery_id })
    end
  end

  def gallery_grid(images, gallery_id, layout)
    grid_classes = case layout
                   when :masonry then "kt-gallery-masonry columns-2 md:columns-3 lg:columns-4 gap-4 p-4"
                   else "kt-gallery-grid grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 p-4"
                   end

    content_tag(:div, class: grid_classes, data: { "kt-gallery": gallery_id }) do
      safe_join(images.map { |image| gallery_image_item(image, gallery_id) })
    end
  end

  def gallery_image_item(image, gallery_id)
    content_tag(:div, class: "kt-gallery-item group relative cursor-pointer overflow-hidden rounded-lg",
                data: { "kt-gallery-item": image[:id] }) do
      concat image_tag(image[:src], alt: image[:alt] || "", class: "kt-gallery-image w-full h-auto object-cover transition-transform group-hover:scale-105")
      concat gallery_image_overlay(image)
    end
  end

  def gallery_image_overlay(image)
    content_tag(:div, class: "kt-gallery-overlay absolute inset-0 bg-black/50 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center") do
      content_tag(:div, class: "kt-gallery-actions flex gap-2") do
        concat ui_icon_button(icon: "eye", variant: :secondary, size: :sm, data: { "kt-gallery-view": image[:id] })
        concat ui_icon_button(icon: "download", variant: :secondary, size: :sm, data: { "kt-gallery-download": image[:id] })
      end
    end
  end

  def gallery_lightbox(gallery_id)
    content_tag(:div, class: "kt-gallery-lightbox fixed inset-0 z-50 hidden bg-black/90", data: { "kt-gallery-lightbox": gallery_id }) do
      concat gallery_lightbox_close_button
      concat gallery_lightbox_image
      concat gallery_lightbox_navigation
    end
  end

  def gallery_lightbox_close_button
    content_tag(:button, class: "kt-gallery-lightbox-close absolute top-4 right-4 text-white", "data-kt-gallery-lightbox-close": true) do
      ui_icon(name: "x", size: :lg)
    end
  end

  def gallery_lightbox_image
    content_tag(:div, class: "kt-gallery-lightbox-image absolute inset-0 flex items-center justify-center p-8") do
      image_tag("", class: "kt-gallery-lightbox-img max-w-full max-h-full object-contain")
    end
  end

  def gallery_lightbox_navigation
    content_tag(:div, class: "kt-gallery-lightbox-nav") do
      concat ui_button(icon: "chevron-left", variant: :secondary, class: "absolute left-4 top-1/2 -translate-y-1/2", data: { "kt-gallery-prev": true })
      concat ui_button(icon: "chevron-right", variant: :secondary, class: "absolute right-4 top-1/2 -translate-y-1/2", data: { "kt-gallery-next": true })
    end
  end

  def build_file_manager_class(additional_class)
    classes = ["kt-file-manager", "border border-border rounded-lg bg-background"]
    classes << additional_class if additional_class
    classes.join(" ")
  end

  def build_gallery_class(layout, additional_class)
    classes = ["kt-gallery", "border border-border rounded-lg bg-background"]
    classes << "kt-gallery-masonry" if layout == :masonry
    classes << additional_class if additional_class
    classes.join(" ")
  end
end