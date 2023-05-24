def find_answers(array1, array2, array3, array4)
  combined = array1 + array2 + array3 + array4
  
  possible_words = []
  
  File.foreach('word_list.txt') do |line|
    if line.chomp.chars.all? { |letter| combined.include?(letter) }
      possible_words << line.chomp
    else
      next
    end
  end
  
  regexp = Regexp.new(format_regexp_string(array1, array2, array3, array4))
  
  final_words = possible_words.reject do |word|
    word.match?(regexp)
  end
  
  puts (final_words.sort_by { |word| word.chars.uniq.count }.reverse.take(150))
  
  # size = 10
  
  # long_words = final_words.select { |word| word.size >= size }
  # single_solve = long_words.select { |word| word.chars.uniq.count >= size }
  # narrow = final_words.select do |word|
  #   word.start_with?("g") &&
  #   word.include?("a") &&
  #   word.include?("p") #&&
  #   # word.include?("p") &&
  #   # word.include?("a")
  # end
  
  # puts possible_words.count
  # puts final_words.count
  # puts long_words.count
  # puts single_solve
  # puts narrow
  
  # Find a way to order it from most letters covered
end

def format_regexp_string(a1, a2, a3, a4)
  s1 = "[#{a1.join}]" * 2
  s2 = "[#{a2.join}]" * 2
  s3 = "[#{a3.join}]" * 2
  s4 = "[#{a4.join}]" * 2
  
  "#{s1}|#{s2}|#{s3}|#{s4}"
end

def solve_letter_boxed_puzzle(letter_groupings)
  all_possible_words = determine_possible_words(letter_groupings)
  one_word_solves = find_one_word_solves(all_possible_words)
  two_word_solves = find_two_word_solves(all_possible_words)
  three_word_solves = find_three_word_solves(all_possible_words, letter_groupings)
  puts "Possible one-word answers:"
  puts one_word_solves
  puts "---"
  puts "Possible two-word answers:"
  puts two_word_solves
  puts "---"
  puts "Possible three-word answers:"
  puts three_word_solves
  puts "---"
end

def determine_possible_words(letter_groupings)
  all_letters = letter_groupings.split(", ").map { |group| group.split("") }
  possible_words = eliminate_words_containing_other_letters(all_letters)
  possible_words = eliminate_words_with_adjacent_letters_in_group(all_letters, possible_words)
end

def eliminate_words_containing_other_letters(all_letters)
  all_letters = all_letters.flatten
  possible_words = []
  
  File.foreach('dictionary.txt') do |word|
    if word.downcase.chomp.chars.all? { |letter| all_letters.include?(letter) } && word.chomp.chars.count >= 3
      possible_words << word.chomp.downcase
    else
      next
    end
  end
  
  return possible_words
end

def eliminate_words_with_adjacent_letters_in_group(all_letters, possible_words)
  letter_group_1 = all_letters[0]
  letter_group_2 = all_letters[1]
  letter_group_3 = all_letters[2]
  letter_group_4 = all_letters[3]
  
  regexp = Regexp.new(format_regexp_string(letter_group_1, letter_group_2, letter_group_3, letter_group_4))
  
  possible_words = possible_words.reject do |word|
    word.match?(regexp)
  end
  
  return possible_words
end
  
def format_regexp_string(letter_group_1, letter_group_2, letter_group_3, letter_group_4)
  regex_group_1 = "[#{letter_group_1.join}]" * 2
  regex_group_2 = "[#{letter_group_2.join}]" * 2
  regex_group_3 = "[#{letter_group_3.join}]" * 2
  regex_group_4 = "[#{letter_group_4.join}]" * 2
  
  # "[abc][abc]|[def][def]|[ghi][ghi]|[jkl][jkl]"
  "#{regex_group_1}|#{regex_group_2}|#{regex_group_3}|#{regex_group_4}"
end

def find_one_word_solves(all_possible_words)
  one_word_answers = all_possible_words.select{ |word| word.chars.uniq.count == 12 }
  one_word_answers.empty? ? "No one word answers found." : one_word_answers.take(10)
end

def find_two_word_solves(all_possible_words)
  two_word_answers = []
  all_possible_words.each do |word|
    all_possible_words.each do |inner_word|
      if (word[-1] == inner_word[0] && (word + inner_word).chars.uniq.count == 12)
        two_word_answers << (word + " " + inner_word)
      end
    end
  end
  
  two_word_answers.empty? ? "No two word answers found." : two_word_answers.take(10)
end

def find_three_word_solves(all_possible_words, letter_groupings)
  three_word_answers = []
  random_start_letter_excluding_x = letter_groupings.split(", ").map { |group| group.split("") }.flatten.reject { |letter| letter == "x" }.sample

  all_possible_words.each do |word|
    break if three_word_answers.count >= 10
    all_possible_words.each do |inner_word|
      next if word[0] != random_start_letter_excluding_x || word[-1] != inner_word[0]
      all_possible_words.each do |innermost_word|
        next if inner_word[-1] != innermost_word[0]
        if ((word + inner_word + innermost_word).chars.uniq.count == 12)
          three_word_answers << (word + " " + inner_word + " " + innermost_word)
        end
      end
    end
  end
  
  three_word_answers.empty? ? "No three word answers found." : three_word_answers
end


# find_answers(["x", "l", "a"], ["m", "a", "e"], ["c", "l", "s"], ["n", "r", "p"])
# find_answers(["x", "l", "a"], ["n", "f", "v"], ["e", "i", "c"], ["k", "r", "b"])

solve_letter_boxed_puzzle("dal, rin, eft, czm")

# desired input: string of letters "xla, nfv, eic, krb"
# desired ouput:
# Possible one-word answers:
  # example
  # example
  # up to 10
# Possible two-word answers:
  # example
  # example
  # up to 10
# Possible three-word answers:
  # example
  # example
  # up to 10