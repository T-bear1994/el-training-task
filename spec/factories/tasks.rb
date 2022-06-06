FactoryBot.define do
  factory :task do
    title { '書類作成' }
    content { '企画書を作成する' }
    deadline_on { '2025-02-18' }
    priority { '中' }
    status { '未着手' }
    association :user
  end

  factory :second_task, class: Task do
    title { 'メール送信' }
    content { '顧客へ営業のメールを送る' }
    deadline_on { '2025-02-17' }
    priority { '高' }
    status { '着手中' }
    association :user, factory: :second_user
  end

  factory :third_task, class: Task do
    title { '家事' }
    content { '掃除機をかける' }
    deadline_on { '2025-02-16' }
    priority { '低' }
    status { '完了' }
    association :user, factory: :third_user
  end

  factory :fourth_task, class: Task do
    title { '学習' }
    content { '現場Railsを読む' }
    deadline_on { '2025-02-19' }
    priority { '高' }
    status { '未着手' }
    association :user, factory: :third_user
  end

  factory :fifth_task, class: Task do
    title { 'バイト' }
    content { '日勤' }
    deadline_on { '2025-02-22' }
    priority { '中' }
    status { '着手中' }
    association :user, factory: :third_user
  end
end
