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

  describe '#remove_word' do
    let(:path) { "#{RSPEC_ROOT}/documents/dictionary_sample.txt" }
    let(:cli) { CLI.new(path) }

    context 'when passing a word in current list' do
      it 'removes it from list, writes to file' do
        expect(cli).to receive(:landing)
        allow(Readline).to receive(:readline).and_return('dolor').once

        begin
          expect { cli.remove_word }.to(
            output("dolor successfuly deleted\n\n").to_stdout
          )
          expect(cli.words).to eq(%w(lorem ipsum sit amet hôpital))
          expect(File.read(path)).to eq('lorem ipsum sit amet hôpital')
        ensure
          File.write(path, 'lorem ipsum dolor sit amet hôpital')
        end
      end
    end

    context 'when passing a word not in current list' do
      it 'does not update list, nor touch file' do
        expect(cli).to receive(:landing)
        allow(Readline).to receive(:readline).and_return('test').once

        begin
          expect { cli.remove_word }.to(
            output("test not found\n\n").to_stdout
          )
          expect(cli.words).to eq(%w(lorem ipsum dolor sit amet hôpital))
          expect(File.read(path)).to eq('lorem ipsum dolor sit amet hôpital')
        ensure
          File.write(path, 'lorem ipsum dolor sit amet hôpital')
        end
      end
    end
  end
end
