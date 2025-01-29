# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Nettoyage de la base de données
puts "Nettoyage de la base de données..."
Property.destroy_all
User.destroy_all

# Création des agents
puts "Création des agents..."

agents = [
  {
    email: 'agent.premium@example.com',
    password: 'password123',
    first_name: 'Pierre',
    last_name: 'Dubois',
    phone_number: '+22890000010',
    role: 'agent',
    plan: 'premium',
    annual: true
  },
  {
    email: 'agent.standard@example.com',
    password: 'password123',
    first_name: 'Marie',
    last_name: 'Martin',
    phone_number: '+22890000011',
    role: 'agent',
    plan: 'standard',
    annual: false
  },
  {
    email: 'agent.basic@example.com',
    password: 'password123',
    first_name: 'Jean',
    last_name: 'Robert',
    phone_number: '+22890000012',
    role: 'agent',
    plan: 'basic',
    annual: false
  }
]

created_agents = agents.map { |agent_data| User.create!(agent_data) }

# Liste des villes
cities = [ 'Lomé', 'Kara', 'Sokodé', 'Kpalimé', 'Atakpamé', 'Bassar', 'Tsévié', 'Aného' ]

# Types de propriétés
property_types = [ 'house', 'apartment', 'land', 'office' ]

# Photos de démonstration
demo_photos = [
  'https://images.unsplash.com/photo-1564013799919-ab600027ffc6',
  'https://images.unsplash.com/photo-1576941089067-2de3c901e126',
  'https://images.unsplash.com/photo-1598228723793-52759bba239c'
]

puts "Création des annonces..."

require 'open-uri'

created_agents.each do |agent|
  3.times do |i|
    # Création de la propriété
    property = Property.create!(
      user: agent,
      title: "Belle propriété #{i + 1} de #{agent.first_name}",
      description: "Une magnifique propriété située dans un quartier prisé de #{cities.sample}. Parfaite pour une famille ou un investissement.",
      price: rand(20_000_000..150_000_000),
      address: "#{rand(1..999)} Rue #{('A'..'Z').to_a.sample}",
      city: cities.sample,
      property_type: property_types.sample,
      transaction_type: [ 'sale', 'rent' ].sample,
      bedrooms: rand(1..5),
      bathrooms: rand(1..3),
      surface: rand(50..500)
    )

    # Ajout des photos (entre 1 et 3 selon le plan)
    max_photos = case agent.plan
    when 'basic' then 2
    when 'standard' then 5
    when 'premium' then 15
    end

    num_photos = rand(1..3) # Pour la démo, on met entre 1 et 3 photos
    num_photos.times do |j|
      begin
        file = URI.open("#{demo_photos[j]}?w=1200&q=80")
        property.photos.attach(
          io: file,
          filename: "property_#{property.id}_photo_#{j+1}.jpg",
          content_type: 'image/jpeg'
        )
      rescue OpenURI::HTTPError => e
        puts "Erreur lors du téléchargement de l'image #{j+1} pour la propriété #{property.id}: #{e.message}"
      end
    end

    puts "Créé propriété #{i + 1} pour #{agent.first_name} avec #{property.photos.count} photos"
  end
end

puts "Terminé ! Création de #{User.count} agents et #{Property.count} propriétés avec #{ActiveStorage::Attachment.count} photos au total."
