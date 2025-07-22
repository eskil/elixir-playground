defmodule CommonWords do
  def find_common(lines) do
    lines
    |> Enum.map(&String.split/1)
    |> Enum.reduce(&Enum.filter(&1, fn word -> word in &2 end))
  end
end

IO.stream(:stdio, :line)
|> Enum.map(&String.trim/1)
|> Enum.reject(&(&1 == ""))
|> CommonWords.find_common()
|> IO.inspect
