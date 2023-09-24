## Solution template for Guess The Word practice problem (section 7)

require_relative './section-7-provided'
require 'set'

class ExtendedGuessTheWordGame < GuessTheWordGame
  ## YOUR CODE HERE
  def initialize secret_word_class
    super 
    @guesses = Set.new
  end

  def ask_for_guessed_letter
    puts "Secret word:"
    puts @secret_word.pattern
    puts @mistakes_allowed.to_s + " incorrect guess(es) left."
    puts "Enter the letter you want uncovered:"
    letter = gets.chomp
    if @secret_word.valid_guess? letter
      if @guesses.include?(letter)
        puts "You have already guessed this letter."
      elsif !@secret_word.guess_letter! letter
        @mistakes_allowed -= 1
        @game_over = @mistakes_allowed == 0
      else
        @game_over = @secret_word.is_solved?
      end
      @guesses << letter.upcase
      @guesses << letter.downcase
    else
      puts "I'm sorry, but that's not a valid letter."
    end
  end

end

class ExtendedSecretWord < SecretWord
  ## YOUR CODE HERE
  def initialize word
    self.word = word
    self.pattern = set_pattern word
  end

  private def set_pattern word 
    pattern = ''
    (0..word.length-1).each{|i|
      if word[i].match(/[\p{P}\s]/)
        pattern.concat(word[i])
      else 
        pattern.concat('-')
      end
    }
    pattern
  end

  def valid_guess? guess
    if guess.length > 1 or guess.match(/[^a-zA-Z]/)
      return false 
    else 
      return true
    end
  end

  def guess_letter! letter
    found = false
    (0..@word.length-1).each{|i| 
      if self.word[i].downcase == letter.downcase
        self.pattern[i] = self.word[i]
        found = true
      end
    }
    found
  end

end

## Change to `false` to run the original game
if true
  ExtendedGuessTheWordGame.new(ExtendedSecretWord).play
else
  GuessTheWordGame.new(SecretWord).play
end