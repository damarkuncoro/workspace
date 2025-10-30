module KT::Profile::ActionsHelper
  # Profile Actions
  def profile_actions(actions = {})
    content_tag(:div) do
      concat(link_to("Edit Profile", protected_profile_edit_path, class: "btn btn-primary"))
      concat(link_to("Back to Dashboard", protected_dashboard_path, class: "btn btn-secondary"))
    end
  end
end
