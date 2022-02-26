#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './lib/hangman'

dictionary = Dictionary.new('google-10000-english-no-swears.txt')
dictionary.load_dictionary

hangman = Hangman.new(dictionary)
hangman.start_menu
