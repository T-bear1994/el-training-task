require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.new(title: '', content: '企画書を作成する。', deadline_on: "2022-03-22", priority: "中", status: "未着手")
        user = User.create(name: "Mike", email: "mike@gmail.com", password:"123456", admin: false)
        task.user_id = user.id
        task.save
        expect(task).not_to be_valid
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.new(title: 'Todo', content: '', deadline_on: "2022-03-22", priority: "中", status: "未着手")
        user = User.create(name: "Mike", email: "mike@gmail.com", password:"123456", admin: false)
        task.user_id = user.id
        task.save
        expect(task).not_to be_valid
      end
    end
    
    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        task = Task.new(title: 'Important!', content: 'qqq', deadline_on: "2022-03-22", priority: "中", status: "未着手")
        user = User.create(name: "Mike", email: "mike@gmail.com", password:"123456", admin: false)
        task.user_id = user.id
        task.save
        expect(task).to be_valid
      end
    end
  end

  describe '検索機能' do
    let!(:first_task) { FactoryBot.create(:task) }
    let!(:second_task) { FactoryBot.create(:second_task) }
    let!(:third_task) { FactoryBot.create(:third_task) }
    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it '検索ワードを含むタスクが絞り込まれる' do
        expect(Task.search_index(title: "メール送信")).to include(second_task)
        expect(Task.search_index(title: "メール送信")).not_to include(first_task)
        expect(Task.search_index(title: "メール送信")).not_to include(third_task)
        expect(Task.search_index(title: "メール送信").count).to eq(1)
      end
    end
    context 'scopeメソッドでステータス検索をした場合' do
      it 'ステータスに完全一致するタスクが絞り込まれる' do
        expect(Task.search_index(status: 1)).to include(second_task)
        expect(Task.search_index(status: 1)).not_to include(first_task)
        expect(Task.search_index(status: 1)).not_to include(third_task)
        expect(Task.search_index(status: 1).count).to eq(1)
      end
    end
    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it '検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞りこまれる' do
        expect(Task.search_index(title: "メール", status: 1)).to include(second_task)
        expect(Task.search_index(title: "メール", status: 1)).not_to include(first_task)
        expect(Task.search_index(title: "メール", status: 1)).not_to include(third_task)
        expect(Task.search_index(title: "メール", status: 1).count).to eq(1)
      end
    end
  end
end
