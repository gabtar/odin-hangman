#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './game/game'
require_relative './game/dictionary'
require_relative './input'

##
# Class for playing hangman games on terminal
class Hangman
  include Input

  attr_reader :game, :dictionary

  def initialize(dictionary)
    @dictionary = dictionary
  end

  def start_menu
    system 'clear'
    loop do
      puts menu
      case validate_input('Select your option: ', '^[1-3]$')
      when '1'
        new_game
      when '2'
        load_game(select_saved_game)
      when '3'
        exit
      end
      play_game
    end
  end

  private

  def menu
    <<~HANGMAN_MENU
      -------------------------
      HANGMAN
      -------------------------
      1) New game
      2) Load game
      3) Exit
      -------------------------
    HANGMAN_MENU
  end

  def new_game
    @game = Game.new(dictionary.select_random_word)
  end

  def play_game
    system 'clear'
    loop do
      puts game
      puts ingame_menu
      game_actions(validate_input('Select option: ', '^[1-2]'))

      break if game.finished?
    end
    end_message
  end

  def game_actions(input)
    case input
    when '1'
      game.play_round(validate_input('Enter a character: ', '^[a-zA-Z]$').downcase)
      system 'clear'
    when '2'
      filename = validate_input('Enter a filename: ', '.')
      save_game(filename)
      system 'clear'
    end
  end

  def end_message
    puts game
    puts 'Game finished'
    if game.lives.zero?
      puts "You lose. Correct answer was: #{game.secret_word.join}"
    else
      puts "You won!!!! Secret word: #{game.secret_word.join}"
    end
  end

  def ingame_menu
    <<~INGAME_MENU
      -------------------------
      Select an option:
      1) Enter a guess
      2) Save current game
      -------------------------
    INGAME_MENU
  end

  def save_game(filename)
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open(File.expand_path("./saves/#{filename}"), 'w') { |file| file.puts game.serialize }
  end

  def load_game(filename)
    @game = Game.unserialize("./saves/#{filename}")
  end

  def select_saved_game
    games = Dir.children('saves')
    puts '-------------------------'
    puts 'Saved games found: '
    games.each { |file| puts file }

    validate_input('Enter filename to load: ', games.join('|'))
  end
end
