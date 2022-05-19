FactoryBot.define do
  factory :first_task, class: Task do
    title { '書類作成' }
    content { '企画書を作成する' }
  end

  factory :second_task, class: Task do
    title { 'メール送信' }
    content { '顧客へ営業のメールを送る' }
  end

  factory :third_task, class: Task do
    title { '家事' }
    content { '掃除機をかける' }
  end
end
