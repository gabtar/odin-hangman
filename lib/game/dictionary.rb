# frozen_string_literal: true

##
# Dictionary of words for the hangman game
class Dictionary
  attr_reader :dictionary, :filename

  def initialize(filename)
    @filename = filename
    @dictionary = []
  end

  def select_random_word
    dictionary[rand(1..(dictionary.length - 1))]
  end

  def load_dictionary
    File.readlines(filename).each do |line|
      dictionary << line.strip if line.length > 5 && line.length < 12
    end
  end
end
