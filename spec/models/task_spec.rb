require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: '', content: '企画書を作成する。')
        expect(task).not_to be_valid
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: 'Important!', content: '')
        expect(task).not_to be_valid
      end
    end
    
    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        task = Task.create(title: 'Test sample', content: 'Content sample', deadline_on: '2025-03-11', priority: '中', status: '未着手')
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
