class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_code.subject
  #
  def activation_code(user)
    @user = user
    @activation_code = user.activation_code
    
    # Attacher le logo
    attachments.inline['logo-ahoefa.svg'] = File.read(Rails.root.join('app/assets/images/logo-ahoefa.svg'))
    
    mail(
      to: user.email,
      subject: "Code d'activation de votre compte Ahoefa"
    )
  end
end
