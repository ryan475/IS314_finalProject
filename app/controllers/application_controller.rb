class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path # Redirect admins to admin dashboard
    elsif resource.super_admin?
      super_admin_dashboard_path # Redirect super admins
    else
      user_profile_path(resource) # Redirect regular users to their profile
    end
  end
end
