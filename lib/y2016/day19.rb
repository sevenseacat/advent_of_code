def part2(elf_count)
  elves = (1..elf_count).to_a
  position = 0

  while elves.length > 1 do
    puts elves.length if elves.length % 10000 == 0 

    opposite_position = opposite(position, elves.length)
    killer = elves[position]    
    killed = elves.delete_at(opposite_position)
    # puts "elf #{killer} (pos #{position}) takes from elf #{killed} (pos #{opposite_position}) (elves left: #{elves.length})"

    # May be different from old position, if an elf lower in number has been killed
    new_position = killed < killer ? position - 1 : position

    position = new_position + 1 == elves.length ? 0 : new_position + 1
  end

  puts "ELVES! #{elves}"
end

def opposite(position, size)
  (size / 2 + position) % size
end

real_input = 3018458
part2((ARGV[0] || real_input).to_i)
