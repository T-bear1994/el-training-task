FactoryBot.define do
  factory :label do
    name { "label_1" }
  end

  factory :second_label, class: Label do
    name { "label_2" }
  end

  factory :third_label, class: Label do
    name { "label_3" }
  end
end
