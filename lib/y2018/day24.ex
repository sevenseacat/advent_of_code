defmodule Y2018.Day24 do
  use Advent.Day, no: 24

  @real_groups [
    # Immune System:
    # 4081 units each with 8009 hit points (immune to slashing, radiation; weak to bludgeoning, cold) with an attack that does 17 fire damage at initiative 7
    %{
      id: {1, :immune},
      units: 4081,
      hp: 8009,
      immune: [:slashing, :radiation],
      weak: [:bludgeoning, :cold],
      attack: {17, :fire},
      initiative: 7,
      targeting: nil
    },
    # 2599 units each with 11625 hit points with an attack that does 36 bludgeoning damage at initiative 17
    %{
      id: {2, :immune},
      units: 2599,
      hp: 11625,
      immune: [],
      weak: [],
      attack: {36, :bludgeoning},
      initiative: 17,
      targeting: nil
    },
    # 4232 units each with 4848 hit points (weak to slashing) with an attack that does 11 bludgeoning damage at initiative 13
    %{
      id: {3, :immune},
      units: 4232,
      hp: 4848,
      immune: [],
      weak: [:slashing],
      attack: {11, :bludgeoning},
      initiative: 13,
      targeting: nil
    },
    # 2192 units each with 8410 hit points (immune to fire, radiation; weak to cold) with an attack that does 36 bludgeoning damage at initiative 18
    %{
      id: {4, :immune},
      units: 2192,
      hp: 8410,
      immune: [:fire, :radiation],
      weak: [:cold],
      attack: {36, :bludgeoning},
      initiative: 18,
      targeting: nil
    },
    # 4040 units each with 8260 hit points (immune to cold) with an attack that does 17 bludgeoning damage at initiative 20
    %{
      id: {5, :immune},
      units: 4040,
      hp: 8260,
      immune: [:cold],
      weak: [],
      attack: {17, :bludgeoning},
      initiative: 20,
      targeting: nil
    },
    # 1224 units each with 4983 hit points (immune to bludgeoning, cold, slashing, fire) with an attack that does 37 radiation damage at initiative 6
    %{
      id: {6, :immune},
      units: 1224,
      hp: 4983,
      immune: [:bludgeoning, :cold, :slashing, :fire],
      weak: [],
      attack: {37, :radiation},
      initiative: 6,
      targeting: nil
    },
    # 1462 units each with 6747 hit points with an attack that does 41 bludgeoning damage at initiative 10
    %{
      id: {7, :immune},
      units: 1462,
      hp: 6747,
      immune: [],
      weak: [],
      attack: {41, :bludgeoning},
      initiative: 10,
      targeting: nil
    },
    # 815 units each with 2261 hit points (weak to cold) with an attack that does 22 cold damage at initiative 19
    %{
      id: {8, :immune},
      units: 815,
      hp: 2261,
      immune: [],
      weak: [:cold],
      attack: {22, :cold},
      initiative: 19,
      targeting: nil
    },
    # 2129 units each with 1138 hit points (weak to radiation, cold) with an attack that does 5 bludgeoning damage at initiative 3
    %{
      id: {9, :immune},
      units: 2129,
      hp: 1138,
      immune: [],
      weak: [:radiation, :cold],
      attack: {5, :bludgeoning},
      initiative: 3,
      targeting: nil
    },
    # 1836 units each with 8018 hit points (immune to radiation) with an attack that does 37 slashing damage at initiative 15
    %{
      id: {10, :immune},
      units: 1836,
      hp: 8018,
      immune: [:radiation],
      weak: [],
      attack: {37, :slashing},
      initiative: 15,
      targeting: nil
    },

    # Infection:
    # 909 units each with 34180 hit points (weak to slashing, bludgeoning) with an attack that does 72 bludgeoning damage at initiative 4
    %{
      id: {1, :infection},
      units: 909,
      hp: 34180,
      immune: [],
      weak: [:slashing, :bludgeoning],
      attack: {72, :bludgeoning},
      initiative: 4,
      targeting: nil
    },
    # 908 units each with 57557 hit points (weak to bludgeoning) with an attack that does 96 fire damage at initiative 14
    %{
      id: {2, :infection},
      units: 908,
      hp: 57557,
      immune: [],
      weak: [:bludgeoning],
      attack: {96, :fire},
      initiative: 14,
      targeting: nil
    },
    # 65 units each with 32784 hit points (weak to cold; immune to bludgeoning) with an attack that does 957 fire damage at initiative 2
    %{
      id: {3, :infection},
      units: 65,
      hp: 32784,
      immune: [:bludgeoning],
      weak: [:cold],
      attack: {957, :fire},
      initiative: 2,
      targeting: nil
    },
    # 5427 units each with 50754 hit points with an attack that does 14 radiation damage at initiative 12
    %{
      id: {4, :infection},
      units: 5427,
      hp: 50754,
      immune: [],
      weak: [],
      attack: {14, :radiation},
      initiative: 12,
      targeting: nil
    },
    # 3788 units each with 27222 hit points (immune to cold, bludgeoning) with an attack that does 14 slashing damage at initiative 16
    %{
      id: {5, :infection},
      units: 3788,
      hp: 27222,
      immune: [:cold, :bludgeoning],
      weak: [],
      attack: {14, :slashing},
      initiative: 16,
      targeting: nil
    },
    # 7704 units each with 14742 hit points (immune to cold) with an attack that does 3 fire damage at initiative 1
    %{
      id: {6, :infection},
      units: 7704,
      hp: 14742,
      immune: [:cold],
      weak: [],
      attack: {3, :fire},
      initiative: 1,
      targeting: nil
    },
    # 5428 units each with 51701 hit points (weak to fire) with an attack that does 14 fire damage at initiative 9
    %{
      id: {7, :infection},
      units: 5428,
      hp: 51701,
      immune: [],
      weak: [:fire],
      attack: {14, :fire},
      initiative: 9,
      targeting: nil
    },
    # 3271 units each with 32145 hit points (weak to bludgeoning, radiation) with an attack that does 19 bludgeoning damage at initiative 8
    %{
      id: {8, :infection},
      units: 3271,
      hp: 32145,
      immune: [],
      weak: [:radiation, :bludgeoning],
      attack: {19, :bludgeoning},
      initiative: 8,
      targeting: nil
    },
    # 99 units each with 49137 hit points with an attack that does 855 fire damage at initiative 5
    %{
      id: {9, :infection},
      units: 99,
      hp: 49137,
      immune: [],
      weak: [],
      attack: {855, :fire},
      initiative: 5,
      targeting: nil
    },
    # 398 units each with 29275 hit points (weak to fire; immune to slashing) with an attack that does 137 cold damage at initiative 11
    %{
      id: {10, :infection},
      units: 398,
      hp: 29275,
      immune: [:slashing],
      weak: [:fire],
      attack: {137, :cold},
      initiative: 11,
      targeting: nil
    }
  ]

  def part1(groups \\ @real_groups, loops \\ 0) do
    {immune, infection} = split_into_armies(groups)

    if immune == [] || infection == [] do
      units_left =
        groups
        |> Enum.map(fn group -> group.units end)
        |> Enum.sum()

      {elem(hd(groups).id, 1), units_left}
    else
      groups
      |> select_targets
      |> attack
      |> part1(loops + 1)
    end
  end

  def part1_with_boost(groups, boost) do
    groups
    |> Enum.map(fn %{id: {_, type}, attack: {atk_power, atk_type}} = group ->
      case type do
        :immune -> %{group | attack: {atk_power + boost, atk_type}}
        :infection -> group
      end
    end)
    |> part1
  end

  def part2(groups \\ @real_groups), do: do_part2(groups, 0)

  defp do_part2(groups, boost) do
    case part1_with_boost(groups, boost) do
      {:infection, _} -> do_part2(groups, boost + 1)
      result -> [result, boost]
    end
  end

  def select_targets(groups) do
    {immune, infection} = split_into_armies(groups)
    select_targets(immune, infection) ++ select_targets(infection, immune)
  end

  def attack(groups) do
    after_attacking =
      groups
      |> Enum.sort_by(fn group -> group.initiative end)
      |> Enum.reverse()
      |> Enum.reduce(groups, fn attacker, groups ->
        attacker = find(groups, attacker.id)

        if attacker == nil || attacker.targeting == nil do
          groups
        else
          attack_group(attacker, groups, [])
        end
      end)

    if groups == after_attacking do
      # Stalemate! Pretend it's an infection win.
      [%{id: {99, :infection}, units: 0, hp: 0}]
    else
      Enum.map(after_attacking, fn group -> Map.put(group, :targeting, nil) end)
    end
  end

  defp attack_group(attacker, [group | groups], seen) do
    if attacker.targeting == group.id do
      dead = div(damage_incurred(group, attacker), group.hp)
      new_units = group.units - dead

      if new_units > 0 do
        [%{group | units: group.units - dead} | groups] ++ seen
      else
        groups ++ seen
      end
    else
      attack_group(attacker, groups, [group | seen])
    end
  end

  defp select_targets(attackers, defenders) do
    attackers
    |> Enum.sort_by(&attacking_selection_order/1)
    |> Enum.reverse()
    |> Enum.reduce({[], []}, fn attacker, {done, targetted} ->
      target = select_target(attacker, defenders -- targetted)

      case target do
        nil ->
          {[attacker | done], targetted}

        target ->
          {
            [%{attacker | targeting: target.id} | done],
            [target | targetted]
          }
      end
    end)
    |> elem(0)
  end

  defp attacking_selection_order(unit), do: {effective_power(unit), unit.initiative}
  defp effective_power(%{units: u, attack: {a, _}}), do: u * a

  defp select_target(_attacker, []), do: nil

  defp select_target(attacker, defenders) do
    case Enum.reject(defenders, fn d -> damage_incurred(d, attacker) == 0 end) do
      [] ->
        nil

      possible ->
        Enum.max_by(possible, fn d ->
          target_selection_order(attacker, d)
        end)
    end
  end

  defp target_selection_order(attacker, defender) do
    {damage_incurred(defender, attacker), effective_power(defender), defender.initiative}
  end

  defp damage_incurred(
         %{weak: weak, immune: immune},
         %{units: u, attack: {val, type}}
       ) do
    cond do
      type in immune -> 0
      type in weak -> 2 * val * u
      true -> val * u
    end
  end

  defp split_into_armies(groups) do
    grouped = Enum.group_by(groups, fn %{id: {_, type}} -> type end)
    {Map.get(grouped, :immune, []), Map.get(grouped, :infection, [])}
  end

  def find(groups, id) do
    Enum.find(groups, fn group -> group.id == id end)
  end

  def part1_verify, do: part1() |> elem(1)
  def part2_verify, do: part2() |> hd() |> elem(1)
end
