defmodule Tournament do
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    initial = %{mp: 0, w: 0, d: 0, l: 0, p: 0}

    scores =
      for line <- input,
          split = String.split(line, ";", trim: true),
          length(split) == 3,
          [team_a, team_b, result] = split,
          result in ["win", "loss", "draw"],
          reduce: %{} do
        acc ->
          acc
          |> Map.update(team_a, update_score(initial, result), &update_score(&1, result))
          |> Map.update(
            team_b,
            update_score(initial, result, :opposite),
            &update_score(&1, result, :opposite)
          )
      end

    header = "Team                           | MP |  W |  D |  L |  P"

    scores =
      scores
      |> Enum.sort(fn {team_a, %{p: a}}, {team_b, %{p: b}} ->
        if a == b, do: team_a <= team_b, else: a > b
      end)
      |> Enum.map(fn {team, %{mp: n, w: w, d: d, l: l, p: p}} ->
        "#{String.pad_trailing(team, 30)} |  #{n} |  #{w} |  #{d} |  #{l} |  #{p}"
      end)

    Enum.join([header | scores], "\n")
  end

  def update_score(score, "win", :opposite), do: update_score(score, "loss")
  def update_score(score, "loss", :opposite), do: update_score(score, "win")
  def update_score(score, "draw", :opposite), do: update_score(score, "draw")

  def update_score(%{mp: n, d: d, p: p} = score, "draw"),
    do: %{score | mp: n + 1, d: d + 1, p: p + 1}

  def update_score(%{mp: n, w: w, p: p} = score, "win"),
    do: %{score | mp: n + 1, w: w + 1, p: p + 3}

  def update_score(%{mp: n, l: l} = score, "loss"),
    do: %{score | mp: n + 1, l: l + 1}
end
