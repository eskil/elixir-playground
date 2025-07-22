IO.stream(:stdio, :line)
|> Enum.map(&String.trim/1)
|> Enum.reject(&(&1 == ""))
|> Enum.map(&String.split/1)
|> Enum.reduce(&Enum.filter(&1, fn word -> word in &2 end))
|> IO.inspect
