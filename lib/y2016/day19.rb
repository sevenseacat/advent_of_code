def part2(elf_count)
  elves = (1..elf_count).to_a
  position = 0

  while elf_count > 1 do
    puts elf_count if elf_count % 10000 == 0 

    opposite_position = opposite(position, elf_count)
    # killer = elves[position]    
    # killed = elves.delete_at(opposite_position)
    elves.delete_at(opposite_position)
    elf_count = elf_count - 1
    # puts "elf #{killer} (pos #{position}) takes from elf #{killed} (pos #{opposite_position}) (elves left: #{elf_count})"

    # May be different from old position, if an elf lower in number has been killed
    new_position = opposite_position < position ? position - 1 : position

    position = new_position + 1 == elf_count ? 0 : new_position + 1
  end

  puts "ELVES! #{elves}"
end

def opposite(position, size)
  (size / 2 + position) % size
end

real_input = 3018458
part2((ARGV[0] || real_input).to_i)
