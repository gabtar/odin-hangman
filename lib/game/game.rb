# frozen_string_literal: true

require 'yaml'
##
# Represents a single game of Hangman
# Every game has a secret word and
class Game
  attr_reader :secret_word, :actual_guess, :lives, :tries

  def initialize(secret_word)
    @secret_word = secret_word.split('')
    @actual_guess = Array.new(@secret_word.length, '_')
    @lives = 6
    @tries = []
  end

  def play_round(char)
    if secret_word.include?(char)
      secret_word.each_with_index do |value, index|
        actual_guess[index] = char if value == char
      end
    else
      @lives -= 1
      @tries << "#{char} - "
    end
  end

  def serialize
    YAML.dump(self)
  end

  def self.unserialize(yaml_string)
    YAML.load_file(yaml_string)
  end

  def finished?
    actual_guess == secret_word || lives.zero?
  end

  def to_s
    <<~GAME_BOARD
      #{display_hangman}

      #{actual_guess.join('  ')}

      Already tried: #{tries.join(' ')}
      Remaining lives: #{lives}
    GAME_BOARD
  end

  private

  def display_hangman
    <<~HANGMAN
        _________
        |         |
        |         |
        |         #{lives < 6 ? 'O' : ''}
        |       #{lives < 4 ? '/ | \ ' : ''}
        |         #{lives < 2 ? '|' : ''}
        |        #{lives.zero? ? '/ \ ' : ''}
        |
      __|________________
    HANGMAN
  end
end
