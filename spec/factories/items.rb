FactoryBot.define do
  factory :item do
    name { Faker::Space.galaxy }
    description { Faker::JapaneseMedia::StudioGhibli.quote }
    unit_price { Faker::Number.decimal(l_digits: 2) }
  end
end
