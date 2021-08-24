defmodule DungeonCrawl.Difficulty do


  def update_game("easy", rooms) do
    {good_rooms, bad_rooms, _} = filter_rooms(rooms)
    new_good_rooms = Enum.map(good_rooms, fn room -> transform_room(room, :increase) end)
    new_bad_rooms = Enum.map(bad_rooms, fn room -> transform_room(room, :decrease) end)
    new_good_rooms ++ new_bad_rooms
  end

  def update_game("normal", rooms) do
    rooms
  end

  def update_game("hard", rooms) do
    {good_rooms, bad_rooms, _} = filter_rooms(rooms)
    new_good_rooms = Enum.map(good_rooms, fn room -> transform_room(room, :decrease) end)
    new_bad_rooms = Enum.map(bad_rooms, fn room -> transform_room(room, :increase) end)
    new_good_rooms ++ new_bad_rooms
  end

  def update_game("crawl", rooms) do
    {good_rooms, bad_rooms, exit_room} = filter_rooms(rooms)
    new_exit_room = Enum.map(exit_room, fn room -> transform_room(room, :increase) end)
    good_rooms ++ bad_rooms ++ new_exit_room
  end

  defp filter_rooms(rooms) do
    good_rooms = Enum.filter(rooms, fn item -> match?(%{type: "heal"}, item) or match?(%{type: "exit"}, item) end)
    bad_rooms = Enum.filter(rooms, fn item -> match?(%{type: "enemy"}, item)  end)
    exit_room = Enum.filter(rooms, fn item -> match?(%{type: "exit"}, item) end)
    {good_rooms, bad_rooms, exit_room}
  end

  defp transform_room(room, :increase) do
     %{room | probability: room.probability + 3}
  end

  defp transform_room(room, :decrease) do
    new_probability = max(0, room.probability - 3)
    %{room | probability: new_probability}
  end

end
