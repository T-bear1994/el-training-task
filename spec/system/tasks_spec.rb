require 'rails_helper'

RSpec.describe "タスク管理機能", type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_user_path
        fill_in "名前", with: "ABC"
        fill_in "メールアドレス", with: "abc@gmail.com"
        fill_in "パスワード", with: "123456"
        fill_in "パスワード(確認)", with: "123456"
        click_button "登録する"
        visit new_task_path
        fill_in "タイトル", with: "Chores"
        fill_in "内容", with: "Laundry"
        fill_in "終了期限", with: "2025-12-12"
        select "中", from: "優先度"
        select "未着手", from: "ステータス"
        click_button "登録する"
        expect(page).to have_content "タスクを登録しました"
        visit tasks_path
        expect(page).to have_content "Laundry"
      end
    end
  end

  describe '一覧表示機能' do
    before do
      task = FactoryBot.create(:third_task) 
      task2 = FactoryBot.create(:fourth_task, user_id: task.user.id)
      task3 = FactoryBot.create(:fifth_task, user_id: task.user.id)
      visit new_session_path
      fill_in "session[email]", with: "nancy@gmail.com"
      fill_in "session[password]", with: "123456"
      click_button "commit"
      visit tasks_path
    end

    context '一覧画面に遷移した場合' do
      it '登録済みのタスク一覧が作成日時の降順で表示される' do
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'バイト'
        expect(task_list[1]).to have_content '学習'
        expect(task_list[2]).to have_content '家事'
      end
    end
    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        visit new_task_path
        fill_in "task[title]", with: "お買い物"
        fill_in "task[content]", with: "マルエツにいく"
        fill_in "task[deadline_on]", with: "2022-04-12"
        select "中", from: "task[priority]"
        select "未着手", from: "task[status]"
        click_button "commit"
        visit tasks_path
        task_list = page.all('tbody tr')
        expect(task_list[0]).to have_content "お買い物"
        expect(task_list[0]).not_to have_content "バイト"
      end
    end

    describe 'ソート機能' do
      context '「終了期限でソートする」というリンクをクリックした場合' do
        it "終了期限昇順に並び替えられたタスク一覧が表示される" do
          visit tasks_path
          click_link '終了期限'
          expect(page.text).to match %r{#{task.title}.*#{task2.title}.*#{task3.title} }
        end
      end
      context '「優先度でソートする」というリンクをクリックした場合' do
        it "優先度の高い順に並び替えられたタスク一覧が表示される" do
          click_link '優先度'
          expect(all('tbody tr')[0]).to have_content "学習"
          expect(all('tbody tr')[1]).to have_content "バイト"
          expect(all('tbody tr')[2]).to have_content "家事"
        end
      end
    end

    describe '検索機能' do
      context 'タイトルであいまい検索をした場合' do
        it "検索ワードを含むタスクのみ表示される" do
          fill_in 'タイトル', with: '学習'
          click_button '検索'
          expect(page).to have_content("現場Railsを読む")
          expect(page).not_to have_content("バイト")
          expect(page).not_to have_content("家事")
        end
      end
      context 'ステータスで検索した場合' do
        it "検索したステータスに一致するタスクのみ表示される" do
          select '未着手', from: 'ステータス'
          click_button '検索'
          expect(page).to have_content("学習")
          expect(page).not_to have_content("家事")
          expect(page).not_to have_content("バイト")
        end
      end
      context 'タイトルとステータスで検索した場合' do
        it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
          fill_in 'タイトル', with: 'バイト'
          select '着手中', from: 'ステータス'
          click_button '検索'
          expect(page).to have_content("日勤")
          expect(page).not_to have_content("学習")
          expect(page).not_to have_content("家事")
        end
      end
    end
  end

  describe '詳細表示機能' do
    before do
      task = FactoryBot.create(:third_task) 
      FactoryBot.create(:fourth_task, user_id: task.user.id)
      FactoryBot.create(:fifth_task, user_id: task.user.id)
      visit new_session_path
      fill_in "session[email]", with: "nancy@gmail.com"
      fill_in "session[password]", with: "123456"
      click_button "commit"
      visit tasks_path
    end


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

  describe '検索機能' do
    before do
      task = FactoryBot.create(:task) 
      task2 = FactoryBot.create(:fourth_task, user_id: task.user.id)
      task3 = FactoryBot.create(:fifth_task, user_id: task.user.id)
      label = FactoryBot.create(:label)
      labelling = FactoryBot.create(:labelling, task: task, label: label)
      visit new_session_path
      fill_in "session[email]", with: "thomas@gmail.com"
      fill_in "session[password]", with: "123456"
      click_button "commit"
      visit tasks_path
    end
    

    context 'ラベルで検索をした場合' do
      it "そのラベルの付いたタスクがすべて表示される" do
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        select 'label_1', from: 'search[label_id]'
        click_button '検索'
        expect(page).to have_content "書類作成"
        expect(page).not_to have_content "メール送信"
      end
    end
  end
end
