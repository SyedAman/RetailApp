FactoryBot.define do
  factory :approval_queue do
    product
    request_date { Time.current }
  end
end