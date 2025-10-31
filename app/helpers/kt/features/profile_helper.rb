# app/helpers/kt/features/profile_helper.rb
module KT
  module Features
    module ProfileHelper
      include KT::Profile::BadgesHelper
      include KT::Profile::ExperienceHelper
      include KT::Profile::SkillsHelper
      include KT::Profile::UploadsHelper
      include KT::Profile::ContributorsHelper
      include KT::Profile::ChartsHelper
      include KT::Profile::InfoHelper
      include KT::Profile::ActionsHelper
      include KT::Profile::CardsHelper
      include KT::Profile::UiHelper
      include KT::UI::Base::BaseUIHelper

      # ===============================
      # 🔹 MAIN PROFILE INTERFACE
      # ===============================

      # ✅ SRP: Complete profile page - unified entry point
      def profile_page(options = {})
        defaults = {
          title: "User Profile",
          description: "Central Hub for Personal Customization",
          actions: default_profile_actions,
          layout: :single_column,
          person: nil,
          customer: nil,
          employee: nil
        }
        config = defaults.merge(options)

        container do
          concat profile_header_section(config[:title], config[:description], config[:actions])
          concat profile_content_section(config)
        end
      end

      private

      # Default profile actions
      def default_profile_actions
        [
          { text: "Public Profile", href: "#", variant: :outline },
          { text: "Account Settings", href: "#", variant: :primary }
        ]
      end

      # Profile header section
      def profile_header_section(title, description, actions)
        content_tag(:div, class: "flex flex-col justify-center gap-2 pb-7.5") do
          concat content_tag(:h1, title, class: "text-xl font-medium leading-none text-mono")
          concat content_tag(:div, description, class: "flex items-center gap-2 text-sm font-normal text-secondary-foreground")
          concat profile_header_actions(actions)
        end
      end

      # Profile header actions
      def profile_header_actions(actions)
        content_tag(:div, class: "flex items-center gap-2.5 pt-4") do
          safe_join(actions.map { |action| ui_button(text: action[:text], href: action[:href], variant: action[:variant]) })
        end
      end

      # Profile content section
      def profile_content_section(config)
        case config[:layout]
        when :single_column
          single_column_profile_layout(config)
        when :two_columns
          two_columns_profile_layout(config)
        else
          single_column_profile_layout(config)
        end
      end

      # Single column layout
      def single_column_profile_layout(config)
        content_tag(:div, class: "grid gap-5 lg:gap-7.5") do
          safe_join([
            personal_info_card(person: config[:person]),
            basic_settings_card(config[:person]),
            work_card,
            badges_card
          ].compact)
        end
      end

      # Two columns layout
      def two_columns_profile_layout(config)
        content_tag(:div, class: "grid grid-cols-1 md:grid-cols-2 gap-5 lg:gap-7.5") do
          safe_join([
            personal_info_card(person: config[:person]),
            basic_settings_card(config[:person]),
            work_card,
            badges_card
          ].compact)
        end
      end
    end
  end
end
