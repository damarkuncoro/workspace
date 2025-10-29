class Protected::BaseController < ApplicationController
  before_action :authenticate_account!
  layout "rr"

end
