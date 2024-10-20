class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin)
      admin_dashboard_path  # Ensure this path matches the route defined
    elsif resource.is_a?(SuperAdmin)
      super_admin_dashboard_path
    else
      user_profile_path(resource)  # Redirect regular users to their profile
    end
  end
end
