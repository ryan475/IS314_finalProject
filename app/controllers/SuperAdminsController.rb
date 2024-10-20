class SuperAdminsController < ApplicationController
  before_action :authenticate_super_admin!

  def dashboard
    @super_admin = current_user
    # Load super admin-specific data
  end
end