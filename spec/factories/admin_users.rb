FactoryBot.define do
  factory :admin_user do
    email { Faker::Internet.email }
    password { "1PA$%abcdefg" }
    password_digest { "$2a$12$TpyckkoMZXo0i4Wu68WGr.xitmlRSw4N0s0wKxk3Q5Zud3FxN4x1m" }
  end
end
