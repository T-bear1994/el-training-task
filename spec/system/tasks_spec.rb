require 'rails_helper'

RSpec.describe "タスク管理機能", type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path
        fill_in "タイトル", with: "Chores"
        fill_in "内容", with: "Laundry"
        fill_in "終了期限", with: "2025-12-12"
        select "中", from: "優先度"
        select "未着手", from: "ステータス"
        click_button "登録する"
        expect(page).to have_content "Laundry"
        expect(page).to have_content "タスクを登録しました"
      end
    end
  end

  describe '一覧表示機能' do
    let!(:first_task) { FactoryBot.create(:task) }
    let!(:second_task) { FactoryBot.create(:second_task) }
    let!(:third_task) { FactoryBot.create(:third_task) }
    before do
      visit tasks_path
    end

    context '一覧画面に遷移した場合' do
      it '登録済みのタスク一覧が作成日時の降順で表示される' do
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content '家事'
        expect(task_list[1]).to have_content 'メール送信'
        expect(task_list[2]).to have_content '書類作成'
      end
    end
    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content '家事'
      end
    end
    describe 'ソート機能' do
      context '「終了期限でソートする」というリンクをクリックした場合' do
        it "終了期限昇順に並び替えられたタスク一覧が表示される" do
          click_link '終了期限'
          expect(Task.all.to_a).to match_array([third_task,second_task,first_task])
        end
      end
      context '「優先度でソートする」というリンクをクリックした場合' do
        it "優先度の高い順に並び替えられたタスク一覧が表示される" do
          click_link '優先度'
          expect(Task.all.to_a).to match_array([second_task,first_task,third_task])
        end
      end
    end
    describe '検索機能' do
      context 'タイトルであいまい検索をした場合' do
        it "検索ワードを含むタスクのみ表示される" do
          fill_in 'タイトル', with: '書類'
          click_button '検索'
          expect(page).to have_content("企画書")
          expect(page).not_to have_content("メール")
          expect(page).not_to have_content("家事")
        end
      end
      context 'ステータスで検索した場合' do
        it "検索したステータスに一致するタスクのみ表示される" do
          select '未着手', from: 'ステータス'
          click_button '検索'
          expect(page).to have_content("書類作成")
          expect(page).not_to have_content("家事")
          expect(page).not_to have_content("メール")
        end
      end
      context 'タイトルとステータスで検索した場合' do
        it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
          fill_in 'タイトル', with: '送信'
          select '着手中', from: 'ステータス'
          click_button '検索'
          expect(page).to have_content("顧客へ営業のメールを送る")
          expect(page).not_to have_content("企画書を作成する")
          expect(page).not_to have_content("掃除機をかける")
        end
      end
    end
  end

  describe '詳細表示機能' do
    let!(:first_task) { FactoryBot.create(:task) }
    let!(:second_task) { FactoryBot.create(:second_task) }

    context '任意のタスク詳細画面に遷移した場合' do
      it 'そのタスクの内容が表示される' do
        task = Task.last
        visit task_path(task.id)
        expect(page).to have_content "タスク詳細ページ"
        expect(page).to have_content task.title
        expect(page).to have_content task.content
      end
    end
  end
end
