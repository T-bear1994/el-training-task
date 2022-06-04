FactoryBot.define do
  factory :user do
    name { "Thomas" }
    email { "thomas@gmail.com" }
    password { "123456" }
    admin { false }
  end

  factory :second_user, class: User do
    name { "Mike" }
    email { "mike@gmail.com" }
    password { "123456" }
    admin { false }
  end

  factory :third_user, class: User do
    name { "Nancy" }
    email { "nancy@gmail.com" }
    password { "123456" }
    admin { false }
  end

  factory :fourth_user, class: User do
    name { "Taylor" }
    email { "taylor@gmail.com" }
    password { "123456" }
    admin { true }
  end
end