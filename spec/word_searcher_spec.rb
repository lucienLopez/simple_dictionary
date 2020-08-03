require 'spec_helper'
require_relative '../app/word_searcher.rb'

RSpec.describe WordSearcher do
  describe '.search_method_1' do
    let(:words) { %w(test testing testo te onion door tesing) }

    context 'when leaving min_size and ending_with empty' do
      it 'returns expected words' do
        expect(WordSearcher.search_method_1(words, nil, 5, 'te', '')).to(
          contain_exactly('test', 'te', 'testo')
        )
      end
    end

    context 'when using all params' do
      it 'returns expected words' do
        expect(WordSearcher.search_method_1(words, 3, 6, 'te', 'ing')).to(
          contain_exactly('tesing')
        )
      end
    end
  end

  describe '.search_method_2' do
    let(:words) { %w(tasting qwesiing sqing other sing tqing) }

    it 'returns expected words' do
      expect(WordSearcher.search_method_2(words, '%s_ing')).to(
        contain_exactly('tasting', 'qwesiing', 'sqing')
      )
    end
  end
end
