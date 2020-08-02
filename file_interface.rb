class FileInterface
  def self.load_words(file_path)
    File.read(file_path).split(' ')
  end

  def self.write_words(file_path, words)
    File.write(file_path, words.join(' '))
  end
end