require_relative './file_interface.rb'
require_relative './word_searcher.rb'
require 'readline'

class CLI
  attr_accessor :words
  attr_accessor :file_path

  def initialize(file_path)
    @file_path = file_path
    @words = FileInterface.load_words(file_path)
  end

  def landing
    answer = prompt(
      "1 - display current words\n2 - add word\n3 - remove word\n4 - search word\n5 - exit\n",
      %w(1 2 3 4 5)
    )

    case answer
    when '1'
      display_current
    when '2'
      add_word
    when '3'
      remove_word
    when '4'
      search_word
    when '5'
      exit(0)
    end
  end

  def display_current
    puts "current words: #{words.join ' - '}\n\n"
    landing
  end

  def add_word
    word = Readline.readline("Which word do you want to add?\n", true)

    if /^[a-zàâçéèêëîïôûùüÿñæœ]*$/.match?(word)
      if words.include?(word)
        puts "#{word} was already in dictionary\n\n"
      else
        words << word
        FileInterface.write_words(file_path, words)
        puts "#{word} successfuly added\n\n"
      end
    else
      puts "Could not add #{word} because it contains characters not in French alphabet\n\n"
    end
    landing
  end

  def remove_word
    word = Readline.readline("Which word do you want to remove?\n", true)
    if words.include?(word)
      words.delete(word)
      FileInterface.write_words(file_path, words)
      puts "#{word} successfuly deleted\n\n"
    else
      puts "#{word} not found\n\n"
    end
    landing
  end

  def search_word
    answer = prompt(
      "1 - method 1\n2 - method 2\n",
      %w(1 2)
    )

    case answer
    when '1'
      search_method_1
    when '2'
      add_word
    end
    landing
  end

  private

  def search_method_1
    min_size = max_size = starting_with = ending_with = nil

    loop do
      answer = Readline.readline("Word minimum size (default none)\n", true)

      if answer.to_i != 0
        min_size = answer.to_i
        continue = true
      end
      break if answer == '' || continue
    end

    loop do
      answer = Readline.readline("Word maximum size (default none)\n", true)

      if answer.to_i != 0
        max_size = answer.to_i
        continue = true
      end
      break if answer == '' || continue
    end

    starting_with = Readline.readline("Word starting with (default none)\n", true)
    ending_with = Readline.readline("Word ending with (default none)\n", true)

    matches = WordSearcher.search_method_1(words, min_size, max_size, starting_with, ending_with)
    puts "Matching words: #{matches.join(', ')}\n\n"
  end

  def search_method_2
    # TODO
  end

  def prompt(text, accepted_answers)
    answer = Readline.readline(text, true)
    until accepted_answers.include?(answer)
      answer = Readline.readline(text, true)
    end
    answer
  end
end
