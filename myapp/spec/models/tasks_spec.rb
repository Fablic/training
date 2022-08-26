require 'rails_helper'

describe Task, type: :model do

  describe '#validation' do

    describe 'title' do

      context '0文字' do

        let(:task) { FactoryBot.build(:task, title: '') }

        it 'invalid' do
          expect(task).to be_invalid
        end

      end

      context '1文字' do

        let(:task) { FactoryBot.build(:task, title: '1') }

        it 'valid' do
          expect(task).to be_valid
        end

      end

      context '128文字' do

        let(:task) { FactoryBot.build(:task, title: '1' * 128) }

        it 'valid' do
          expect(task).to be_valid
        end

      end

      context '129文字' do

        let(:task) { FactoryBot.build(:task, title: '1' * 129) }

        it 'invalid' do
          expect(task).to be_invalid
        end

      end

    end

    describe 'content' do

      context '0文字' do

        let(:task) { FactoryBot.build(:task, content: '') }

        it 'invalid' do
          expect(task).to be_invalid
        end

      end

      context '1文字' do

        let(:task) { FactoryBot.build(:task, content: '1') }

        it 'valid' do
          expect(task).to be_valid
        end

      end

      context '1024文字' do

        let(:task) { FactoryBot.build(:task, content: '1' * 1024) }

        it 'valid' do
          expect(task).to be_valid
        end

      end

      context '1025文字' do

        let(:task) { FactoryBot.build(:task, content: '1' * 1025) }

        it 'invalid' do
          expect(task).to be_invalid
        end

      end

    end

    describe 'label' do

      context '0文字' do

        let(:task) { FactoryBot.build(:task, label: '') }

        it 'invalid' do
          expect(task).to be_invalid
        end

      end

      context '1文字' do

        let(:task) { FactoryBot.build(:task, label: '1') }

        it 'valid' do
          expect(task).to be_valid
        end

      end

      context '64文字' do

        let(:task) { FactoryBot.build(:task, label: '1' * 64) }

        it 'valid' do
          expect(task).to be_valid
        end

      end

      context '65文字' do

        let(:task) { FactoryBot.build(:task, label: '1' * 65) }

        it 'invalid' do
          expect(task).to be_invalid
        end

      end

    end

  end

end
