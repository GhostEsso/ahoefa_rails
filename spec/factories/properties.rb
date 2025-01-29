FactoryBot.define do
  factory :property do
    title { "MyString" }
    description { "MyText" }
    price { "9.99" }
    address { "MyString" }
    city { "MyString" }
    property_type { "MyString" }
    bedrooms { 1 }
    bathrooms { 1 }
    surface { "9.99" }
    user { nil }
  end
end
