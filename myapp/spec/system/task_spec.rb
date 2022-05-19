require 'rails_helper'

RSpec.describe Task, type: :system do
  describe 'kaminari' do
    let(:kaminari_data_per_page) { described_class.default_per_page }
    let(:kaminari_link_page) { '<span class="page">' }
    let(:kaminari_link_current_page) { '<span class="page current">' }
    let(:kaminari_link_previous) { I18n.t('views.pagination.previous') }
    let(:kaminari_link_next) { I18n.t('views.pagination.next') }
    let(:kaminari_link_first) { I18n.t('views.pagination.first') }
    let(:kaminari_link_last) { I18n.t('views.pagination.last') }

    context 'タスクデータが存在する場合' do
      let!(:tasks) { create_list(:task, kaminari_data_per_page * 2 + 1) }

      context '最初のページを開いている場合' do
        it '一覧画面に1 ~ 5番目(index: 10 ~ 6)のタスクデータ、ページリンク(「前」,「最初」除く)が表示されること' do
          get tasks_path

          expect(response.body).not_to include tasks[0].title.to_s
          expect(response.body).not_to include tasks[1].title.to_s
          expect(response.body).not_to include tasks[2].title.to_s
          expect(response.body).not_to include tasks[3].title.to_s
          expect(response.body).not_to include tasks[4].title.to_s
          expect(response.body).not_to include tasks[5].title.to_s
          expect(response.body).to include tasks[6].title.to_s
          expect(response.body).to include tasks[7].title.to_s
          expect(response.body).to include tasks[8].title.to_s
          expect(response.body).to include tasks[9].title.to_s
          expect(response.body).to include tasks[10].title.to_s

          expect(response.body).to include kaminari_link_page
          expect(response.body).to include kaminari_link_current_page
          expect(response.body).not_to include kaminari_link_previous
          expect(response.body).to include kaminari_link_next
          expect(response.body).not_to include kaminari_link_first
          expect(response.body).to include kaminari_link_last
        end
      end

      context '中間のページを開いている場合' do
        it '一覧画面に6 ~ 10番目(index: 5 ~ 1)のタスクデータ、全てのページリンクが表示されること' do
          get tasks_path, params: { page: 2 }

          expect(response.body).not_to include tasks[0].title.to_s
          expect(response.body).to include tasks[1].title.to_s
          expect(response.body).to include tasks[2].title.to_s
          expect(response.body).to include tasks[3].title.to_s
          expect(response.body).to include tasks[4].title.to_s
          expect(response.body).to include tasks[5].title.to_s
          expect(response.body).not_to include tasks[6].title.to_s
          expect(response.body).not_to include tasks[7].title.to_s
          expect(response.body).not_to include tasks[8].title.to_s
          expect(response.body).not_to include tasks[9].title.to_s
          expect(response.body).not_to include tasks[10].title.to_s

          expect(response.body).to include kaminari_link_page
          expect(response.body).to include kaminari_link_current_page
          expect(response.body).to include kaminari_link_previous
          expect(response.body).to include kaminari_link_next
          expect(response.body).to include kaminari_link_first
          expect(response.body).to include kaminari_link_last
        end
      end

      context '最後のページを開いている場合' do
        it '一覧画面に11番目(index: 0)のタスクデータ、ページリンク(「次」,「最後」除く)が表示されること' do
          get tasks_path, params: { page: 3 }

          expect(response.body).to include tasks[0].title.to_s
          expect(response.body).not_to include tasks[1].title.to_s
          expect(response.body).not_to include tasks[2].title.to_s
          expect(response.body).not_to include tasks[3].title.to_s
          expect(response.body).not_to include tasks[4].title.to_s
          expect(response.body).not_to include tasks[5].title.to_s
          expect(response.body).not_to include tasks[6].title.to_s
          expect(response.body).not_to include tasks[7].title.to_s
          expect(response.body).not_to include tasks[8].title.to_s
          expect(response.body).not_to include tasks[9].title.to_s
          expect(response.body).not_to include tasks[10].title.to_s

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
