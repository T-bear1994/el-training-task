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
        task = Task.create(title: 'Test sample', content: 'Content sample')
        expect(task).to be_valid
      end
    end
  end

  describe '検索機能' do
    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it '検索ワードを含むタスクが絞り込まれる' do
        first_task = Task.create(title: 'Sample task', content: 'sample content', deadline_on: '2025-02-18', priority: '中', status: '未着手')
        second_task = Task.create(title: 'Sample task2', content: 'sample content2', deadline_on: '2025-02-17', priority: '高', status: '着手中')
        third_task = Task.create(title: 'task', content: 'content', deadline_on: '2025-02-16', priority: '低', status: '完了')
        
        expect(first_task).to be_valid

      end
    end
    context 'scopeメソッドでステータス検索をした場合' do
      it 'ステータスに完全一致するタスクが絞り込まれる' do

      end
    end
    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it '検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞りこまれる' do

      end
    end
  end
end
