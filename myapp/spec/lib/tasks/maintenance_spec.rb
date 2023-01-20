require 'rails_helper'

describe 'maintenance' do
  include_context 'rake'

  let(:mock_file) { StringIO.new() }

  before do
    allow(YAML).to receive(:load_file).with('maintinance.yml').and_return(current_mode)
    allow(File).to receive(:open).and_yield(mock_file)
  end

  after do
    mock_file.truncate(0)
    mock_file.rewind
  end

  describe '#starts' do
    let(:task_name) { 'maintenance:starts' }

    context 'when mode is off' do
      let(:current_mode) { {'mode' => 'off'} }

      it 'updates the mode' do
        subject.invoke
        expect(mock_file.string).to eq('mode: on')
      end
    end

    context 'when mode is on' do
      let(:current_mode) { {'mode' => 'on'} }

      it 'does not update the mode' do
        subject.invoke
        expect(mock_file).not_to receive(:open)
      end
    end
  end

  describe '#stops' do
    let(:task_name) { 'maintenance:stops' }

    context 'when mode is off' do
      let(:current_mode) { {'mode' => 'off'} }

      it 'updates the mode' do
        subject.invoke
        expect(mock_file.string).to eq('mode: off')
      end
    end

    context 'when mode is on' do
      let(:current_mode) { {'mode' => 'on'} }

      it 'does not update the mode' do
        subject.invoke
        expect(mock_file).not_to receive(:open)
      end
    end
  end
end
