require 'rails_helper'

RSpec.describe Task, type: :system do
  kaminari_data_per_page = 5
  kaminari_link_page = '<span class="page">'.freeze
  kaminari_link_current_page = '<span class="page current">'.freeze
  kaminari_link_previous = I18n.t('views.pagination.previous').freeze
  kaminari_link_next = I18n.t('views.pagination.next').freeze
  kaminari_link_first = I18n.t('views.pagination.first').freeze
  kaminari_link_last = I18n.t('views.pagination.last').freeze

  describe 'kaminari' do
    context 'タスクデータが存在する場合' do
      let!(:tasks) { create_list(:task, kaminari_data_per_page + 1) }

      context '最初のページを開いている場合' do
        it "一覧画面に1 ~ #{kaminari_data_per_page}番目のタスクデータ、ページリンク(#{kaminari_link_previous},#{kaminari_link_first}除く)が表示されること" do
          get tasks_path

          expect(response.body).not_to include tasks[0].title.to_s
          expect(response.body).to include tasks[1].title.to_s
          expect(response.body).to include tasks[kaminari_data_per_page - 1].title.to_s

          expect(response.body).to include kaminari_link_page
          expect(response.body).to include kaminari_link_current_page
          expect(response.body).not_to include kaminari_link_previous
          expect(response.body).to include kaminari_link_next
          expect(response.body).not_to include kaminari_link_first
          expect(response.body).to include kaminari_link_last
        end
      end

      context '最後のページを開いている場合' do
        it "一覧画面に#{kaminari_data_per_page + 1}番目のタスクデータ、ページリンク(#{kaminari_link_next},#{kaminari_link_last}除く)が表示されること" do
          get tasks_path, params: { page: 2 }

          expect(response.body).to include tasks[0].title.to_s
          expect(response.body).not_to include tasks[1].title.to_s
          expect(response.body).not_to include tasks[kaminari_data_per_page - 1].title.to_s

          expect(response.body).to include kaminari_link_page
          expect(response.body).to include kaminari_link_current_page
          expect(response.body).to include kaminari_link_previous
          expect(response.body).not_to include kaminari_link_next
          expect(response.body).to include kaminari_link_first
          expect(response.body).not_to include kaminari_link_last
        end
      end
    end

    context 'タスクデータが存在しない場合' do
      let!(:tasks) {}

      it '一覧画面にタスクデータ、ページリンクが一切表示されないこと' do
        get tasks_path

        expect(response.body).not_to include kaminari_link_page
        expect(response.body).not_to include kaminari_link_current_page
        expect(response.body).not_to include kaminari_link_previous
        expect(response.body).not_to include kaminari_link_next
        expect(response.body).not_to include kaminari_link_first
        expect(response.body).not_to include kaminari_link_last
      end
    end
  end
end
