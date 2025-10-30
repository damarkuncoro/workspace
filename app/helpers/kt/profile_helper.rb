# app/helpers/kt/profile_helper.rb
module KT::ProfileHelper
  include KT::Profile::BadgesHelper
  include KT::Profile::ExperienceHelper
  include KT::Profile::SkillsHelper
  include KT::Profile::UploadsHelper
  include KT::Profile::ContributorsHelper
  include KT::Profile::ChartsHelper
  include KT::Profile::InfoHelper
  include KT::Profile::ActionsHelper

end