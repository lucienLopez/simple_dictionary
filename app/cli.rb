require_relative './file_interface.rb'
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
    # TODO
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
    # TODO
    landing
  end

  private

  def prompt(text, accepted_answers)
    answer = Readline.readline(text, true)
    until accepted_answers.include?(answer)
      answer = Readline.readline(text, true)
    end
    answer
  end
end
