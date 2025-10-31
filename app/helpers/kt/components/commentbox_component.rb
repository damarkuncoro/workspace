# app/helpers/kt/components/commentbox_component.rb
module KT::Components::CommentboxComponent
  include KT::BaseUiHelper

  # ✅ SRP: Basic comment box component
  def ui_comment_box(comments: [], allow_reply: true, **options)
    comment_id = options[:id] || "comments-#{SecureRandom.hex(4)}"
    classes = build_comment_box_class(options.delete(:class))

    content_tag(:div, class: classes, **options) do
      concat comment_list(comments, allow_reply)
      concat comment_form(comment_id) if allow_reply
    end
  end

  # ✅ SRP: Single comment component
  def ui_comment(comment:, show_replies: true, allow_reply: true, **options)
    content_tag(:div, class: "kt-comment", **options) do
      concat comment_header(comment)
      concat comment_content(comment)
      concat comment_actions(comment, allow_reply)
      concat comment_replies(comment[:replies], show_replies, allow_reply) if comment[:replies]&.any?
    end
  end

  # ✅ SRP: Comment form
  def ui_comment_form(placeholder: "Write a comment...", submit_text: "Post Comment", **options)
    form_id = options[:id] || "comment-form-#{SecureRandom.hex(4)}"

    content_tag(:form, class: "kt-comment-form", **options) do
      concat comment_textarea(placeholder, form_id)
      concat comment_form_actions(submit_text, form_id)
    end
  end

  private

  def comment_list(comments, allow_reply)
    content_tag(:div, class: "kt-comment-list space-y-6") do
      safe_join(comments.map { |comment| ui_comment(comment: comment, allow_reply: allow_reply) })
    end
  end

  def comment_header(comment)
    content_tag(:div, class: "kt-comment-header flex items-center gap-3 mb-3") do
      concat ui_avatar(src: comment[:avatar], size: :sm)
      concat content_tag(:div, class: "kt-comment-meta") do
        concat content_tag(:div, comment[:author], class: "kt-comment-author font-medium text-sm")
        concat content_tag(:div, comment[:time], class: "kt-comment-time text-xs text-muted-foreground")
      end
    end
  end

  def comment_content(comment)
    content_tag(:div, class: "kt-comment-content mb-3") do
      content_tag(:p, comment[:content], class: "text-sm leading-relaxed")
    end
  end

  def comment_actions(comment, allow_reply)
    actions = []
    actions << comment_action_button("Like", "heart", comment[:likes] || 0, "kt-comment-like")
    actions << comment_action_button("Reply", "message-circle", nil, "kt-comment-reply") if allow_reply
    actions << comment_action_menu(comment[:id]) if comment[:can_edit] || comment[:can_delete]

    content_tag(:div, class: "kt-comment-actions flex items-center gap-4") do
      safe_join(actions)
    end
  end

  def comment_action_button(text, icon, count = nil, css_class = "")
    content_tag(:button, class: "kt-comment-action flex items-center gap-1 text-xs text-muted-foreground hover:text-foreground #{css_class}") do
      concat ui_icon(name: icon, size: :xs)
      concat content_tag(:span, text)
      concat content_tag(:span, "(#{count})", class: "ml-1") if count && count > 0
    end
  end

  def comment_action_menu(comment_id)
    ui_context_menu(
      trigger: ui_icon_button(icon: "more-vertical", size: :xs, variant: :ghost),
      items: [
        { text: "Edit", icon: "edit", href: "#", data: { "kt-comment-edit": comment_id } },
        { text: "Delete", icon: "trash", href: "#", data: { "kt-comment-delete": comment_id } }
      ]
    )
  end

  def comment_replies(replies, show_replies, allow_reply)
    return "" unless show_replies

    content_tag(:div, class: "kt-comment-replies mt-4 ml-8 border-l-2 border-muted pl-6 space-y-4") do
      safe_join(replies.map { |reply| ui_comment(comment: reply, allow_reply: allow_reply) })
    end
  end

  def comment_form(comment_id)
    content_tag(:div, class: "kt-comment-form-container mt-6 pt-6 border-t border-border") do
      ui_comment_form
    end
  end

  def comment_textarea(placeholder, form_id)
    text_area_tag(:content, "", placeholder: placeholder, class: "kt-comment-textarea kt-input w-full resize-none", rows: 3,
                  data: { "kt-comment-input": true, "kt-comment-form": form_id })
  end

  def comment_form_actions(submit_text, form_id)
    content_tag(:div, class: "kt-comment-form-actions flex justify-between items-center mt-3") do
      concat content_tag(:div, class: "kt-comment-form-hints text-xs text-muted-foreground") do
        "Press Ctrl+Enter to submit"
      end
      concat ui_button(text: submit_text, size: :sm, data: { "kt-comment-submit": form_id })
    end
  end

  def build_comment_box_class(additional_class)
    classes = ["kt-comment-box"]
    classes << additional_class if additional_class
    classes.join(" ")
  end
end