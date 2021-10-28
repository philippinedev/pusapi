FactoryBot.define do
  factory :admin_user do
    email { Faker::Internet.email }
    password { "password" }
    password_digest { "$2a$04$jDxrHkVncT476oB6eWMV5.Lad5U55Gm.d3/NRuWngQHxXCc/pSFIq" }
  end
end
