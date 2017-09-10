require 'byebug'
class Array

  # Monkey patch the Array class and add a my_inject method. If my_inject receives
  # no argument, then use the first element of the array as the default accumulator.
  #
  # def my_inject2(accumulator = nil, &prc)
  #   copy = self.dup                        # => [1, 2, 3, 4, 5]
  #
  #   accumulator = copy.shift  # => 1
  #
  #   copy.each do |el|                          # => [2, 3, 4, 5]
  #     accumulator = prc.call(accumulator, el)  # => 3, 6, 10, 15
  #   end                                        # => [2, 3, 4, 5]
  #   accumulator                                # => 15
  # end                                          # => :my_inject2


  def my_inject(accumulator = nil, &prc)
    copy = self.dup

    accumulator = copy.shift  if accumulator.nil?

    copy.each do |el|
      accumulator = prc.call(accumulator, el)
    end
    accumulator
  end
end

# [*1..5].my_inject2(15) {|acc,el| acc+el}  # ~> NoMethodError: undefined method `my_inject2' for [1, 2, 3, 4, 5]:Array\nDid you mean?  my_inject

# primes(num) returns an array of the first "num" primes.
# You may wish to use an is_prime? helper method.

def is_prime?(num)
  return false if num == 1
  [*2...num].each {|i| return false if num % i == 0}
  true
end

def primes(num)
  arr_primes = []
  current_num = 2

  until arr_primes.length == num
    arr_primes << current_num if is_prime?(current_num)
    current_num+=1
  end
  arr_primes
end


# Write a recursive method that returns the first "num" factorial numbers.
# Note that the 1st factorial number is 0!, which equals 1. The 2nd factorial
# is 1!, the 3rd factorial is 2!, etc.

def factorials_rec(n)
  return [1] if n <= 1

  facts = factorials_rec(n-1)
  facts << facts.last * (n-1)
end

class Array

  # Write an Array#dups method that will return a hash containing the indices of all
  # duplicate elements. The keys are the duplicate elements; the values are
  # arrays of their indices in ascending order, e.g.
  # [1, 3, 4, 3, 0, 3, 0].dups => { 3 => [1, 3, 5], 0 => [4, 6] }

  def dups
    dup_array = Hash.new { |hash, key| hash[key] = []}

    self.each_with_index {|el,idx| dup_array[el] << idx}

    dup_array.select {|k,v| v.length > 1}
  end
end

# [1,2,1,3].dups  # => {1=>[0, 2]}

class String
  def symmetric_substrings
    return [] if self.length <=1

    arr_palidromes = self.is_palindrome? ? [self] : []
    left = self[0...-1] .symmetric_substrings
    right = self[1..-1] .symmetric_substrings

    arr_palidromes += right + left
    arr_palidromes.uniq
  end

  def is_palindrome?
    self == self.reverse
  end
end

# "xabax".symmetric_substrings

class Array

  # Write an Array#merge_sort method; it should not modify the original array.

  def merge_sort(&prc)
    return self if self.length <= 1
    prc ||= Proc.new { |x, y| x <=> y }

    midpoint = self.length / 2
    left = self.take(midpoint).merge_sort(&prc)
    right = self.drop(midpoint).merge_sort(&prc)
    Array.merge(left, right, &prc)
  end

  private
  def self.merge(left, right, &prc)
    merged = []

    until left.empty? || right.empty?
      case prc.call(left,right)
      when -1
        merged << left.shift
      when 0
        merged << left.shift
      when 1
        merged << right.shift
      end
    end

    merged + left + right
  end
end

[1, 2, 3, 4, 5].shuffle.merge_sort
