require 'rails_helper'

describe 'maintenance' do
  let(:file_path) { 'tmp/maintenance.txt' }

  describe 'start' do
    let(:rake) { Rake.application['maintenance:start'] }

    context 'without maintenance.txt file' do
      it 'creates maintenance.txt' do
        rake.execute
        expect(File).to exist(file_path)
        File.delete(file_path) if File.exist?(file_path) # celan up after test
      end
    end

    context 'with maintenance.txt file' do
      before do
        File.open('tmp/maintenance.txt', 'w'){ |f| f.write('')}
      end

      it 'just updates maintenance.txt and no error' do
        rake.execute
        expect(File).to exist(file_path)
        File.delete(file_path) if File.exist?(file_path) # celan up after test
      end
    end
  end

  describe 'finish' do
    let(:rake) { Rake.application['maintenance:finish'] }

    context 'without maintenance.txt file' do
      it 'has no error' do
        rake.execute
        expect(File).not_to exist(file_path)
      end
    end

    context 'with maintenance.txt file' do
      before do
        File.open('tmp/maintenance.txt', 'w'){ |f| f.write('')}
      end

      it 'deletes maintenance.txt' do
        rake.execute
        expect(File).not_to exist(file_path)
      end
    end
  end
end
