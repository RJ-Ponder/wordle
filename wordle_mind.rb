require 'colorize'
require_relative 'guess_words'
require_relative 'key_words'
require 'pry'

class Wordle
  attr_accessor :secret_word, :num_guesses, :guesses, :secret_word_length, :guess_count, :guess_scores, :scores
  
  def initialize(secret_word, num_guesses)
    @secret_word = secret_word.upcase
    @secret_word_length = @secret_word.length
    @num_guesses = num_guesses
    @guesses = Hash.new
    @guess_count = 1
    

    @guess_scores = {}
    @scores = [0, 0, 0] # make it's own class?
  end

  def generate_game_board
    counter = 1
    puts "               " + "=> good, okay, bad"
    while counter <= num_guesses
      puts divider_line
      puts guess_line(counter)
      puts divider_line if counter == num_guesses
      counter += 1
    end
  end
  
  def divider_line
    "   +" + "-+" * (secret_word_length)
  end
  
  def guess_line(counter)
    beginning = "#{counter.to_s.rjust(2, " ")} |"
    middle = if @guesses[counter] != nil
               @guesses[counter]
             else
               (" " * secret_word_length).chars.join("|")
             end
    last = "|"
    beginning + middle + last + " => " + score(counter)
  end
  
  def score(counter)
    if @guess_scores[counter]
       @guess_scores[counter].join(", ")
    else
      ""
    end
    # return a string with the score
  end

  def get_indexed_letter(word)
    indexed_letter = {}
    word.chars.each_with_index do |value, index|
      indexed_letter[index] = value
    end
    indexed_letter
  end
  
  def get_letter_frequency(word)
    frequency = Hash.new(0)
    secret_word.chars.each do |letter|
      frequency[letter] += 1
    end
    frequency
  end
  
  def process_colors(guess)
    indexed_secret_word = get_indexed_letter(secret_word)
    indexed_guess = get_indexed_letter(guess)
    secret_word_letter_frequency = get_letter_frequency(secret_word)
    colorized_guess = Hash.new(0)
    green_and_yellow_counts = Hash.new(0)
    
    indexed_guess.each do |key, value|
      if indexed_guess[key] == indexed_secret_word[key]
        colorized_guess[key] = value
        guess_scores[guess_count] = scores
        guess_scores[guess_count][0] += 1
        green_and_yellow_counts[value] += 1
      else
        colorized_guess[key] = value
        
      end
    end
    
    indexed_guess.each do |key, value|
      if indexed_guess[key] == indexed_secret_word[key]
        next
      elsif indexed_secret_word.values.include?(value) && (green_and_yellow_counts[value] < secret_word_letter_frequency[value])
        colorized_guess[key] = value
        guess_scores[guess_count] = scores
        guess_scores[guess_count][1] += 1
        green_and_yellow_counts[value] += 1
      else
        guess_scores[guess_count] = scores
        guess_scores[guess_count][2] += 1
        next
      end
    end

    return colorized_guess.values.join("|")
  end

  def play
    puts "Welcome to Wordle!".red
    puts "The secret word has #{secret_word.length} letters.".yellow
    puts "You have #{num_guesses} guesses to find the word.".green
    puts "Enter your guess below:"
    
    until won? || lost?
      generate_game_board # Board.display clear the boards except messages
      @scores = [0, 0, 0]
      guess = gets.chomp.upcase
      
      if guess.length != secret_word.length
        puts "Your guess must have exactly #{secret_word.length} letters."
      elsif !GUESS_WORDS.include?(guess.downcase) && !KEY_WORDS.include?(guess.downcase)
        puts "Your guess must be a valid word."
      elsif guess == secret_word
        @guesses[guess_count] = process_colors(guess)
        break
      else
        @guesses[guess_count] = process_colors(guess)
        @guess_count += 1
      end
    end
    
    generate_game_board

    if won?
      puts "Congratulations, you won! The secret word was '#{secret_word}'."
    else
      puts "Sorry, you lost. The secret word was '#{secret_word}'."
    end
  end

  def won?
    @guesses.values.any? do |guess|
      guess.split("|").join.uncolorize == secret_word
    end
  end

  def lost?
    guess_count > num_guesses
  end
end

class GameBoard
  # number of guesses in a game
  # access to the guesses collection
  def self.display(guesses_collection)
    
  end
end

Wordle.new(KEY_WORDS.sample, 10).play

# REFACTORING
## extract all messaging to its own class or file
## create a game board display class
## create a guess class
## create a secret word class
## create a keyboard display class, potentially a part of the game board