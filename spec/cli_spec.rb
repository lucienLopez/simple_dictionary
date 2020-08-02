require 'spec_helper'
require_relative '../app/cli.rb'

RSpec.describe CLI do
  describe '.initialize' do
    let(:path) { "#{RSPEC_ROOT}/documents/dictionary_sample.txt" }
    let(:cli) { CLI.new(path) }

    it 'correctly sets file_path and words' do
      expect(cli.file_path).to eq(path)
      expect(cli.words).to eq(%w(lorem ipsum dolor sit amet hôpital))
    end
  end

  describe '#landing' do
    let(:cli) { CLI.new("#{RSPEC_ROOT}/documents/dictionary_empty.txt") }
    context 'when user presses 1' do
      it 'calls display_current' do
        expect(cli).to receive(:display_current)
        allow(cli).to receive(:prompt).and_return('1').once

        cli.landing
      end
    end

    context 'when user presses 2' do
      it 'calls display_current' do
        expect(cli).to receive(:add_word)
        allow(cli).to receive(:prompt).and_return('2').once

        cli.landing
      end
    end

    context 'when user presses 3' do
      it 'calls display_current' do
        expect(cli).to receive(:remove_word)
        allow(cli).to receive(:prompt).and_return('3').once

        cli.landing
      end
    end

    context 'when user presses 4' do
      it 'calls display_current' do
        expect(cli).to receive(:search_word)
        allow(cli).to receive(:prompt).and_return('4').once

        cli.landing
      end
    end

    context 'when user presses 5' do
      it 'calls display_current' do
        allow(cli).to receive(:prompt).and_return('5').once
        expect { cli.landing }.to raise_exception(SystemExit)
      end
    end
  end

  describe '#display_current' do
    let(:cli) { CLI.new("#{RSPEC_ROOT}/documents/dictionary_sample.txt") }

    it 'displays current words' do
      expect(cli).to receive(:landing)
      expect { cli.display_current }.to(
        output("current words: lorem - ipsum - dolor - sit - amet - hôpital\n\n").to_stdout
      )
    end
  end
end
