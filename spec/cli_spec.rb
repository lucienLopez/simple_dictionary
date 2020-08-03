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

    context 'when passing a word in current dictionary' do
      it 'removes it from dictionary, writes to file' do
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

    context 'when passing a word not in current dictionary' do
      it 'does not update dictionary, nor touches file' do
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

  describe '#add_word' do
    let(:path) { "#{RSPEC_ROOT}/documents/dictionary_sample.txt" }
    let(:cli) { CLI.new(path) }

    context 'when passing a word with only French characters' do
      context 'when passing a word in current dictionary' do
        it 'does not update dictionary, nor touches file' do
          expect(cli).to receive(:landing)
          allow(Readline).to receive(:readline).and_return('dolor').once

          begin
            expect { cli.add_word }.to(
              output("dolor was already in dictionary\n\n").to_stdout
            )
            expect(cli.words).to eq(%w(lorem ipsum dolor sit amet hôpital))
            expect(File.read(path)).to eq('lorem ipsum dolor sit amet hôpital')
          ensure
            File.write(path, 'lorem ipsum dolor sit amet hôpital')
          end
        end
      end

      context 'when passing a word not in current dictionary' do
        it 'adds it to dictionary, writes to file' do
          expect(cli).to receive(:landing)
          allow(Readline).to receive(:readline).and_return('aiguë').once

          begin
            expect { cli.add_word }.to(
              output("aiguë successfuly added\n\n").to_stdout
            )
            expect(cli.words).to eq(%w(lorem ipsum dolor sit amet hôpital aiguë))
            expect(File.read(path)).to eq('lorem ipsum dolor sit amet hôpital aiguë')
          ensure
            File.write(path, 'lorem ipsum dolor sit amet hôpital')
          end
        end
      end
    end

    context 'when passing a word containing non-French characters' do
      it 'does not update dictionary, nor touches file' do
        expect(cli).to receive(:landing)
        allow(Readline).to receive(:readline).and_return('dørø').once

        begin
          expect { cli.add_word }.to(
            output(
              "Could not add dørø because it contains characters not in French alphabet\n\n"
            ).to_stdout
          )
          expect(cli.words).to eq(%w(lorem ipsum dolor sit amet hôpital))
          expect(File.read(path)).to eq('lorem ipsum dolor sit amet hôpital')
        ensure
          File.write(path, 'lorem ipsum dolor sit amet hôpital')
        end
      end
    end
  end

  describe '#search_word' do
    let(:cli) { CLI.new("#{RSPEC_ROOT}/documents/dictionary_empty.txt") }

    context 'when user selects search_method_1' do
      let(:answers) { ['1', '', '5', 'tes', ''] }
      it 'calls WordSearcher.search_method_1 with the right params' do
        prompt_number = 0
        allow(Readline).to receive(:readline).at_most(5).time do
          answer = answers[prompt_number]
          prompt_number += 1
          answer
        end

        expect(cli).to receive(:landing)
        expect(WordSearcher).to(receive(:search_method_1).with([], nil, 5, 'tes', ''))
          .and_return(%w(testing test))


        expect { cli.search_word }.to(
          output("Matching words: testing, test\n\n").to_stdout
        )
      end
    end

    context 'when user selects search_method_2' do
      context 'when passing valid query' do
        let(:answers) { %w(2 _ing%) }

        it 'calls WordSearcher.search_method_2 with the right params' do
          prompt_number = 0
          allow(Readline).to receive(:readline).at_most(2).time do
            answer = answers[prompt_number]
            prompt_number += 1
            answer
          end

          expect(cli).to receive(:landing)
          expect(WordSearcher).to(receive(:search_method_2).with([], '_ing%'))
            .and_return(%w(testing test))


          expect { cli.search_word }.to(
            output("Matching words: testing, test\n\n").to_stdout
          )
        end
      end

      context 'when passing invalid query' do
        it 'asks for another input'
      end
    end
  end
end
