require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'UserModelのバリデーションチェック' do
    let(:user) { create(:user) }
    let(:user_valid) { user.valid? }
    let(:second_user) { create(:user, email: 'second-test@example.com') }

    context 'nameの値が空欄の時' do
      it 'バリデーションがFalseになる事' do
        user.name = ''
        expect(user_valid).to eq false
      end
    end

    context 'nameの値がnilの時' do
      it 'バリデーションがFalseになる事' do
        user.name = nil
        expect(user_valid).to eq false
      end
    end

    context 'nameの値が56文字以上の時' do
      it 'バリデーションがFalseになる事' do
        user.name = Faker::Lorem.characters(number: 56)
        expect(user_valid).to eq false
      end
    end

    context 'emailが空欄の時' do
      it 'バリデーションがFalseになる事' do
        user.email = ''
        expect(user_valid).to eq false
      end
    end

    context 'emailがnilの時' do
      it 'バリデーションがFalseになる事' do
        user.email = nil
        expect(user_valid).to eq false
      end
    end

    context 'nameの値が256文字以上の時' do
      it 'バリデーションがFalseになる事' do
        user.email = "#{'a' * 245}@example.com"
        expect(user_valid).to eq false
      end
    end

    context 'emailの値が有効なメールフォーマットの時' do
      it 'バリデーションがtrueになる事' do
        valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                             first.last@foo.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
          user.email = valid_address
          expect(user_valid).to eq true
        end
      end
    end

    context 'emailの値が重複した時' do
      it 'バリデーションがfalseになる事' do
        second_user.email = user.email
        expect(second_user.valid?).to eq false
      end
    end

    context 'emailの値が同一の値で全て大文字だったで重複した時' do
      it 'バリデーションがfalseになる事' do
        second_user.email = user.email.upcase
        expect(second_user.valid?).to eq false
      end
    end

    context 'emailの値が大文字と小文字が混在してる時' do
      it '小文字に変換されて登録される事' do
        mixed_case_email = 'Foo@ExAMPle.CoM'
        user.email = mixed_case_email
        user.save
        expect(mixed_case_email.downcase).to eq user.reload.email
      end
    end

    context 'passwordが8文字未満だった場合' do
      it 'バリデーションがfalseになる事' do
        user.password = user.password_confirmation = 'a' * 7
        expect(user.valid?).to eq false
      end
    end

    context 'passwordが空文字8文字だった場合' do
      it 'バリデーションがfalseになる事' do
        user.password = user.password_confirmation = ' ' * 8
        expect(user.valid?).to eq false
      end
    end
  end
end
