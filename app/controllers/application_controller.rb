class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :get_updates

  def current_user
    Current&.user
  end

  private

  def get_updates
    if params&.fetch(:id, nil).present?
      @updates = Update.where(updatable_id: params[:id])
    end
  end
end
