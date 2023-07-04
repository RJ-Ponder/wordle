# generate 6 random numbers between 1 and 25
# perform a random math operation between each one
# if answer is not whole number or negative, choose a different math operation

def generate_random_number
  (1..25).to_a.sample
end

def assign_number(array)
  array.shuffle!.pop
end

# array = [1, 2, 3, 4, 5, 10]
# array = [2, 3, 9, 10, 15, 25]
array = [1, 2, 7, 10, 12, 15]
# array = [3, 5, 6, 7, 8, 15]
# array = [5, 7, 9, 13, 19, 20]

a = assign_number(array)
b = assign_number(array)
c = assign_number(array)
d = assign_number(array)
e = assign_number(array)
f = assign_number(array)

assigned_array = [a, b, c, d, e, f]

operators = [:+, :-, :*, :/]

op_1 = a.to_f.send(operators.sample, b)
until (op_1 % 1).zero? && op_1 < 200 && op_1 > 0
    op_1 = a.to_f.send(operators.sample, b)
end
    
op_2 = op_1.to_f.send(operators.sample, c)
until (op_2 % 1).zero? && op_2 < 200 && op_2 > 0
    op_2 = op_1.to_f.send(operators.sample, c)
end

op_3 = op_2.to_f.send(operators.sample, d)
until (op_3 % 1).zero? && op_3 < 200 && op_3 > 0
    op_3 = op_2.to_f.send(operators.sample, d)
end

op_4 = op_3.to_f.send(operators.sample, e)
until (op_4 % 1).zero? && op_4 < 200 && op_4 > 0
    op_4 = op_3.to_f.send(operators.sample, e)
end

op_5 = op_4.to_f.send(operators.sample, f)
until (op_5 % 1).zero? && op_5 < 200 && op_5 > 0
    op_5 = op_4.to_f.send(operators.sample, f)
end

def show_numbers(array)
  puts array.sort.join(", ")
end

show_numbers(assigned_array)
puts op_5.to_i