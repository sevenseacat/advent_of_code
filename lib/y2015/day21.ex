defmodule Y2015.Day21 do
  use Advent.Day, no: 21

  @boss %{hp: 100, damage: 8, armor: 2}

  def part1 do
    weapons = [
      %{cost: 8, damage: 4, name: "Dagger"},
      %{cost: 10, damage: 5, name: "Shortsword"},
      %{cost: 25, damage: 6, name: "Warhammer"},
      %{cost: 40, damage: 7, name: "Longsword"},
      %{cost: 74, damage: 8, name: "Greataxe"}
    ]

    armor = [
      %{cost: 13, armor: 1, name: "Leather"},
      %{cost: 31, armor: 2, name: "Chainmail"},
      %{cost: 53, armor: 3, name: "Splintmail"},
      %{cost: 75, armor: 4, name: "Bandedmail"},
      %{cost: 102, armor: 5, name: "Platemail"},
      # no armor
      %{}
    ]

    rings = [
      %{cost: 25, damage: 1, name: "Damage +1"},
      %{cost: 50, damage: 2, name: "Damage +2"},
      %{cost: 100, damage: 3, name: "Damage +3"},
      %{cost: 20, armor: 1, name: "Armor +1"},
      %{cost: 40, armor: 2, name: "Armor +2"},
      %{cost: 80, armor: 3, name: "Armor +3"}
    ]

    ring_loadouts =
      Advent.combinations(rings, 0) ++
        Advent.combinations(rings, 1) ++ Advent.combinations(rings, 2)

    for(
      x <- weapons,
      y <- armor,
      z <- ring_loadouts,
      do: [x, y | z]
    )
    |> Enum.sort_by(fn loadout -> stat_for_loadout(loadout, :cost) end)
    |> find_winning_loadout()
    |> stat_for_loadout(:cost)
  end

  defp find_winning_loadout([]), do: nil

  defp find_winning_loadout([loadout | rest]) do
    player = %{
      hp: 100,
      armor: stat_for_loadout(loadout, :armor),
      damage: stat_for_loadout(loadout, :damage)
    }

    {winner, _, _} = fight(player, @boss)

    if winner == :player do
      loadout
    else
      find_winning_loadout(rest)
    end
  end

  defp stat_for_loadout(loadout, stat) do
    loadout |> Enum.map(&(&1[stat] || 0)) |> Enum.sum()
  end

  @doc """
  Who wins out of the player and boss?

  iex> Day21.fight(%{hp: 8, damage: 5, armor: 5}, %{hp: 12, damage: 7, armor: 2})
  {:player, %{hp: 2, damage: 5, armor: 5}, %{hp: 0, damage: 7, armor: 2}}
  """
  def fight(player, boss, turn \\ :player)

  def fight(%{hp: player_hp} = player, %{hp: boss_hp} = boss, turn) do
    cond do
      player_hp <= 0 ->
        {:boss, player, boss}

      boss_hp <= 0 ->
        {:player, player, boss}

      true ->
        {player, boss, turn} = attack(player, boss, turn)
        fight(player, boss, turn)
    end
  end

  @doc """
  iex> Day21.attack(%{hp: 8, damage: 5, armor: 5}, %{hp: 12, damage: 7, armor: 2}, :player)
  {%{hp: 8, damage: 5, armor: 5}, %{hp: 9, damage: 7, armor: 2}, :boss}

  iex> Day21.attack(%{hp: 8, damage: 5, armor: 5}, %{hp: 9, damage: 7, armor: 2}, :boss)
  {%{hp: 6, damage: 5, armor: 5}, %{hp: 9, damage: 7, armor: 2}, :player}
  """
  def attack(player, boss, :player), do: {player, do_attack(player, boss), :boss}
  def attack(player, boss, :boss), do: {do_attack(boss, player), boss, :player}

  defp do_attack(%{damage: damage}, %{hp: hp, armor: armor} = defender) do
    %{defender | hp: hp - max(damage - armor, 1)}
  end

  def part1_verify, do: part1()
end
