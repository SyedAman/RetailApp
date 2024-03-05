FactoryBot.define do
  factory :product do
    name { "Product Name" }
    price { 1000 }
    status { true }
  end
end