require 'rails_helper'

RSpec.describe User, type: :model do
  let(:name_max_length) { 50 }
  let(:email_max_length) { 255 }
  let(:password_minimum_length) { 8 }
  # passwordの最大文字数(72)はhas_secure_passwordによるバリデーションに依存
  let(:password_maximum_length) { 72 }
  let(:number_of_multiple_data) { 5 }

  shared_examples_for 'バリデーションエラーとなり、想定するメッセージが表示されること' do |column, message|
    it {
      expect(user.valid?).to eq false
      user.valid?
      expect(user.errors.messages[column]).to include message
    }
  end

  describe 'name' do
    let(:user) { build(:user, name: name) }

    context '名前に正常な値が入力されている場合' do
      let(:name) { 'a' * num }

      context '名前が50文字の場合' do
        let(:num) { name_max_length }

        it 'バリデーションエラーにならないこと' do
          expect(user.valid?).to eq true
        end
      end

      context '名前が51文字以上の場合' do
        let(:num) { name_max_length + 1 }

        it 'バリデーションエラーになること' do
          expect(user.valid?).to eq false
        end

        it 'エラーメッセージが表示されること' do
          user.valid?
          expect(user.errors.messages[:name]).to include "は#{name_max_length}文字以内で入力してください"
        end
      end
    end

    context '名前に正常な値が入力されていない場合' do
      context '名前が空の場合' do
        let(:name) { '' }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :name, I18n.t('errors.messages.blank')
      end

      context '名前が空白の場合' do
        let(:name) { ' ' }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :name, I18n.t('errors.messages.blank')
      end

      context '名前がnilの場合' do
        let(:name) { nil }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :name, I18n.t('errors.messages.blank')
      end
    end
  end

  describe 'email' do
    let(:user) { build(:user, email: email) }

    context 'メールアドレスに正常な値が入力されている場合' do
      let(:email) { 'a' * num }

      context 'メールアドレスが255文字の場合' do
        let(:num) { email_max_length }

        it 'バリデーションエラーにならないこと' do
          expect(user.valid?).to eq true
        end
      end

      context 'メールアドレスが256文字以上の場合' do
        let(:num) { email_max_length + 1 }

        it 'バリデーションエラーになること' do
          expect(user.valid?).to eq false
        end

        it 'エラーメッセージが表示されること' do
          user.valid?
          expect(user.errors.messages[:email]).to include "は#{email_max_length}文字以内で入力してください"
        end
      end
    end

    context 'メールアドレスに正常な値が入力されていない場合' do
      context 'メールアドレスが空の場合' do
        let(:email) { '' }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :email, I18n.t('errors.messages.blank')
      end

      context 'メールアドレスが空白の場合' do
        let(:email) { ' ' }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :email, I18n.t('errors.messages.blank')
      end

      context 'メールアドレスがnilの場合' do
        let(:email) { nil }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :email, I18n.t('errors.messages.blank')
      end
    end
  end

  describe 'password' do
    let(:user) { build(:user, password: password) }

    context 'パスワードに正常な値が入力されている場合' do
      let(:password) { 'a' * num }

      context 'パスワードが8文字の場合' do
        let(:num) { password_minimum_length }

        it 'バリデーションエラーにならないこと' do
          expect(user.valid?).to eq true
        end
      end

      context 'パスワードが72文字の場合' do
        let(:num) { password_maximum_length }

        it 'バリデーションエラーにならないこと' do
          expect(user.valid?).to eq true
        end
      end

      context 'パスワードが8文字未満の場合' do
        let(:num) { password_minimum_length - 1 }

        it 'バリデーションエラーになること' do
          expect(user.valid?).to eq false
        end

        it 'エラーメッセージが表示されること' do
          user.valid?
          expect(user.errors.messages[:password]).to include "は#{password_minimum_length}文字以上で入力してください"
        end
      end

      context 'パスワードが73文字以上の場合' do
        let(:num) { password_maximum_length + 1 }

        it 'バリデーションエラーになること' do
          expect(user.valid?).to eq false
        end

        it 'エラーメッセージが表示されること' do
          user.valid?
          expect(user.errors.messages[:password]).to include "は#{password_maximum_length}文字以内で入力してください"
        end
      end
    end

    context 'パスワードに正常な値が入力されていない場合' do
      context 'パスワードが空の場合' do
        let(:password) { '' }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :password, I18n.t('errors.messages.blank')
      end

      context 'パスワードが空白の場合' do
        let(:password) { ' ' }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :password, I18n.t('errors.messages.blank')
      end

      context 'パスワードがnilの場合' do
        let(:password) { nil }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :password, I18n.t('errors.messages.blank')
      end
    end
  end

  describe 'admin' do
    let(:user) { build(:user, admin: admin) }

    context '管理者権限に正常な値が入力されている場合' do
      context '真偽値の場合' do
        context 'trueの場合' do
          let(:admin) { true }

          it 'バリデーションエラーにならないこと' do
            user.valid?
            expect(user.valid?).to eq true
          end
        end

        context 'falseの場合' do
          let(:admin) { false }

          it 'バリデーションエラーにならないこと' do
            user.valid?
            expect(user.valid?).to eq true
          end
        end
      end

      context '真偽値以外の場合' do
        let(:admin) { 'invalid_role' }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :admin, I18n.t('activerecord.errors.models.user.invalid_value')
      end
    end

    context '管理者権限に正常な値が入力されていない場合' do
      context '管理者権限が空の場合' do
        let(:admin) { '' }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :admin, I18n.t('activerecord.errors.models.user.invalid_value')
      end

      context '管理者権限が空白の場合' do
        let(:admin) { ' ' }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :admin, I18n.t('activerecord.errors.models.user.invalid_value')
      end

      context '管理者権限がnilの場合' do
        let(:admin) { nil }

        it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること', :admin, I18n.t('activerecord.errors.models.user.invalid_value')
      end
    end
  end

  describe 'scope' do
    let!(:users) { create_list(:user, number_of_multiple_data) }

    describe 'all_sort_by' do
      subject { proc { User.all_sort_by(column, order) } }

      context '作成日時が指定された場合' do
        let(:column) { :created_at }

        context '昇順が指定された場合' do
          let(:order) { :asc }

          it '作成日時(昇順)で並び替えられた全てのデータを取得していること' do
            before_user = nil
            get_users = subject.call

            expect(get_users.size).to eq(number_of_multiple_data)
            get_users.each do |user|
              expect(user.send(column.to_s)).to be >= before_user.send(column.to_s) if before_user
              before_user = user
            end
          end
        end

        context '降順が指定された場合' do
          let(:order) { :desc }

          it '作成日時(降順)で並び替えられた全てのデータを取得していること' do
            before_user = nil
            get_users = subject.call

            expect(get_users.size).to eq(number_of_multiple_data)
            get_users.each do |user|
              expect(user.send(column.to_s)).to be <= before_user.send(column.to_s) if before_user
              before_user = user
            end
          end
        end
      end
    end
  end
end
