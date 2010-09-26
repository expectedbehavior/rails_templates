  before_filter :require_user
  after_filter  :store_location
  
  helper_method :current_user_session, :current_user
