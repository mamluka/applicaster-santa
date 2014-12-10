require 'thor'
require 'pry'

class Santa < Thor
  desc 'give', 'Give a present'

  def give
    people = STDIN.read.split("\n").sort_by { Random.rand }

    cyclic_people_list = people.map { |x| x.split(' ') }
                             .group_by { |x| x[1] }
                             .values
                             .map
                             .with_index { |ppl, i| calculate_index ppl, i, people.length }
                             .flatten(1)
                             .sort_by { |x| x[1] }
                             .map { |x| x[0] }


    (cyclic_people_list << cyclic_people_list.first).each_slice(2) { |x|
      $stdout.puts "#{x[0][0]} #{x[0][1]} send an email to #{x[1][0]} #{x[1][1]}"
    }

  end

  private

  def calculate_index(ppl, i, total_people)
    family_size = ppl.count
    return [[ppl.first, i]] if family_size == 1

    ppl.map.with_index { |p, p_index|
      [p, (p_index+1) * total_people/family_size]
    }
  end
end

Santa.start