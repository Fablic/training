require 'rails_helper'

RSpec.describe 'Tag', type: :model do
  let(:user) { create(:user) }

  describe 'normal case' do
    context 'all valid parameters' do
      let(:tag) {
        Tag.new(user: user,
                 name: 'sample_tag')
      }

      it 'has no error' do
        tag.valid?
        expect(tag.errors.count).to eq 0
      end
    end
  end

  describe 'validation' do
    describe 'name' do
      context 'length is 0' do
        let(:tag) {
          Tag.new(user: user,
                   name: '')
        }

        it 'has validation error' do
          tag.valid?
          expect(tag.errors.count).to eq 1
          expect(tag.errors[:name].present?).to be true
        end
      end

      context 'length is 1' do
        let(:tag) {
          Tag.new(user: user,
                   name: 'a')
        }

        it 'has no error' do
          tag.valid?
          expect(tag.errors.count).to eq 0
        end
      end

      context 'length is 20' do
        let(:tag) {
          Tag.new(user: user,
                   name: 'a' * 20)
        }

        it 'has no error' do
          tag.valid?
          expect(tag.errors.count).to eq 0
        end
      end

      context 'length is 21' do
        let(:tag) {
          Tag.new(user: user,
                   name: 'a' * 21)
        }

        it 'has validation error' do
          tag.valid?
          expect(tag.errors.count).to eq 1
          expect(tag.errors[:name].present?).to be true
        end
      end
    end
  end
end
