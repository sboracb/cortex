FactoryBot.define do
  factory :cortex_contract, class: 'Cortex::Contract' do
    name {Faker::Lorem.word}
    association :tenant, factory: :cortex_tenant
  end
end
