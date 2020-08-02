require 'spec_helper'
require_relative '../app/file_interface.rb'

RSpec.describe FileInterface do
  describe '.load_words' do
    context 'when passing a valid path' do
      it 'returns expected words' do
        words = FileInterface.load_words(
          "#{RSPEC_ROOT}/documents/dictionary_sample.txt"
        )
        expect(words).to(
          contain_exactly('lorem', 'ipsum', 'dolor', 'sit', 'amet', 'hôpital')
        )
      end
    end

    context 'when passing an invalid path' do
      it 'raises correct exception' do
        expect do
          FileInterface.load_words("#{RSPEC_ROOT}/documents/fake_path.txt")
        end.to raise_exception(Errno::ENOENT)
      end
    end
  end

  describe '.write_words' do
    it 'returns expected words' do
      path = "#{RSPEC_ROOT}/documents/write_words_spec.txt"

      begin
        FileInterface.write_words(path, %w(lorem ipsum dolor sit amet hôpital))
        expect(File.read(path)).to eq('lorem ipsum dolor sit amet hôpital')
      ensure
        File.delete(path) if File.exist?(path)
      end
    end
  end
end
