defmodule Y2015.Day22.GameState do
  defstruct mode: nil,
            winner: nil,
            player: nil,
            boss: nil,
            mana_spent: 0,
            turn: :player,
            effects: []
end

defmodule Y2015.Day22 do
  use Advent.Day, no: 22

  alias Y2015.Day22.GameState

  @player %{hp: 50, mana: 500, armor: 0}
  @boss %{hp: 55, damage: 8}
  @attacks [
    %{name: :magic_missile, cost: 53, damage: 4},
    %{name: :drain, cost: 73, damage: 2, healing: 2},
    %{name: :shield, cost: 113, turns: 6, armor: 7},
    %{name: :poison, cost: 173, turns: 6, damage: 3},
    %{name: :recharge, cost: 229, turns: 5, regen: 101}
  ]

  def part1(player \\ @player, boss \\ @boss) do
    run_fights([%GameState{player: player, boss: boss, mode: :normal}], nil)
  end

  def part2(player \\ @player, boss \\ @boss) do
    run_fights([%GameState{player: player, boss: boss, mode: :hard}], nil)
  end

  def run_fights([], min_mana), do: min_mana

  def run_fights([%GameState{} = state | scenarios], min_mana) do
    state = maybe_apply_penalty(state)

    %GameState{player: player, boss: boss, turn: turn, effects: effects} =
      state = apply_effects(state)

    cond do
      min_mana && state.mana_spent > min_mana ->
        run_fights(scenarios, min_mana)

      player.hp <= 0 ->
        run_fights(scenarios, min_mana)

      boss.hp <= 0 ->
        min_mana = if min_mana, do: min(min_mana, state.mana_spent), else: state.mana_spent
        run_fights(scenarios, min_mana)

      turn == :player ->
        case possible_attacks(player, effects) do
          [] ->
            run_fights(scenarios, min_mana)

          attacks ->
            new_scenarios =
              Enum.map(attacks, fn attack ->
                %{
                  apply_player_attack(attack, state)
                  | turn: :boss,
                    mana_spent: state.mana_spent + attack.cost
                }
              end)

            run_fights(new_scenarios ++ scenarios, min_mana)
        end

      turn == :boss ->
        run_fights([apply_boss_attack(state) | scenarios], min_mana)
    end
  end

  defp maybe_apply_penalty(%GameState{player: player, turn: turn, mode: mode} = state) do
    if mode == :hard && turn == :player do
      %{state | player: %{player | hp: player.hp - 1}}
    else
      state
    end
  end

  def possible_attacks(player, effects) do
    @attacks
    |> Enum.filter(fn %{name: poss_name, cost: cost} ->
      cost <= player.mana &&
        !Enum.any?(effects, fn %{name: in_effect_name} -> in_effect_name == poss_name end)
    end)
  end

  def apply_boss_attack(%GameState{player: player, boss: boss} = state) do
    %{
      state
      | turn: :player,
        player: %{player | hp: player.hp - max(boss.damage - player.armor, 1)}
    }
  end

  def apply_player_attack(
        %{name: :magic_missile} = attack,
        %GameState{player: player, boss: boss} = state
      ) do
    %{
      state
      | player: %{player | mana: player.mana - attack.cost},
        boss: %{boss | hp: boss.hp - attack.damage}
    }
  end

  def apply_player_attack(
        %{name: :drain} = attack,
        %GameState{player: player, boss: boss} = state
      ) do
    %{
      state
      | player: %{player | mana: player.mana - attack.cost, hp: player.hp + attack.healing},
        boss: %{boss | hp: boss.hp - attack.damage}
    }
  end

  def apply_player_attack(
        %{name: :shield} = attack,
        %GameState{player: player, effects: effects} = state
      ) do
    %{
      state
      | player: %{player | mana: player.mana - attack.cost, armor: player.armor + attack.armor},
        effects: [attack | effects]
    }
  end

  def apply_player_attack(
        attack,
        %GameState{player: player, effects: effects} = state
      ) do
    %{state | player: %{player | mana: player.mana - attack.cost}, effects: [attack | effects]}
  end

  def apply_effects(%GameState{effects: []} = state), do: state

  def apply_effects(%GameState{player: player, boss: boss, effects: effects} = state) do
    {player, boss, effects} =
      Enum.reduce(effects, {player, boss, []}, fn effect, {player, boss, effects} ->
        {player, boss, effect} = apply_effect(effect, player, boss)
        {player, boss, [effect | effects]}
      end)

    %{state | player: player, boss: boss, effects: Enum.filter(effects, &(!is_nil(&1)))}
  end

  defp apply_effect(%{name: :shield, armor: armor} = effect, player, boss) do
    effect = tick(effect)

    if effect do
      {player, boss, effect}
    else
      {%{player | armor: player.armor - armor}, boss, effect}
    end
  end

  defp apply_effect(%{name: :poison, damage: damage} = effect, player, boss) do
    {player, %{boss | hp: boss.hp - damage}, tick(effect)}
  end

  defp apply_effect(%{name: :recharge, regen: regen} = effect, player, boss) do
    {%{player | mana: player.mana + regen}, boss, tick(effect)}
  end

  defp tick(%{turns: 1}), do: nil
  defp tick(effect), do: %{effect | turns: effect.turns - 1}

  def part1_verify, do: part1()
  def part2_verify, do: part2()
end
