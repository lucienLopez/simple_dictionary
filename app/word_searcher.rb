class WordSearcher
  def self.search_method_1(words, min_size, max_size, starting_with, ending_with)
    matches = []

    words .each do |word|
      next if min_size && word.length < min_size
      next if max_size && word.length > max_size
      next unless starting_with.empty? || word[0, starting_with.length] == starting_with
      unless ending_with.empty? ||
             word[word.length - ending_with.length, word.length] == ending_with
        next
      end

      matches << word
    end

    matches
  end
end
