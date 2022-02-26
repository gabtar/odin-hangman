# frozen_string_literal: true

##
# Mixin for validating custom inputs with a regex expresion
module Input
  # Loops until a valid input acording to rule is typed in terminal
  # And returns the string selected
  def validate_input(message, rule)
    input = ''
    loop do
      print message
      input = gets.chomp
      break if input.match?(rule)

      puts 'Invalid input'
    end
    input
  end
end
