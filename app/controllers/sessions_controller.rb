class SessionsController < Devise::SessionsController
  def create
    Rails.logger.debug "Tentative de connexion pour: #{params[:user][:email]}"
    super do |user|
      Rails.logger.debug "Utilisateur connecté: #{user.inspect}"
      Rails.logger.debug "Est admin?: #{user.admin?}"
    end
  end
end 