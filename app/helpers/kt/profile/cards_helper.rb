module KT::Profile::CardsHelper
  include KT::Profile::InfoHelper
  include KT::Profile::UiHelper

  # ==========================================================
  # 🔹 Personal Info Card
  # ==========================================================
  def personal_info_card(person: nil)
    # Delegate to InfoHelper implementation
    KT::Profile::InfoHelper.instance_method(:personal_info_card).bind(self).call(person: person)
  end

  # ==========================================================
  # 🔹 Basic Settings Card
  # ==========================================================
  def basic_settings_card(account = nil)
    # Delegate to InfoHelper implementation
    KT::Profile::InfoHelper.instance_method(:basic_settings_card).bind(self).call(account)
  end

  # ==========================================================
  # 🔹 Work Card
  # ==========================================================
  def work_card(account = nil)
    # Delegate to InfoHelper implementation
    KT::Profile::InfoHelper.instance_method(:work_card).bind(self).call(account)
  end

  private

  # ==========================================================
  # 🔹 Generic Card Component
  # ==========================================================
  def card_component(title, &block)
    content_tag(:div, class: "kt-card") do
      concat(content_tag(:div, title, class: "kt-card-header text-lg font-semibold mb-3"))
      concat(content_tag(:div, capture(&block), class: "kt-card-content p-4"))
    end
  end
end
