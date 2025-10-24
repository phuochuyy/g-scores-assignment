class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protected

  def valid_sbd_format?(sbd)
    sbd.present? && sbd.strip.match?(/\A[0-9]{8}\z/)
  end
end
