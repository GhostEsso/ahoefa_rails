# Création de l'administrateur par défaut
Rails.application.config.after_initialize do
  if Rails.env.development? && User.find_by(email: 'admin@ahoefa.com').nil?
    User.create!(
      email: 'admin@ahoefa.com',
      password: '12345678',
      password_confirmation: '12345678',
      first_name: 'Admin',
      last_name: 'Ahoefa',
      phone_number: '+22890000001',
      role: 'admin',
      plan: 'basic'
    )
    puts 'Administrateur par défaut créé avec succès!'
  end
end 