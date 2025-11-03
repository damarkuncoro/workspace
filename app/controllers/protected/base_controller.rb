class Protected::BaseController < ApplicationController
  before_action :authenticate_account!
  layout "metronic_application"
end
