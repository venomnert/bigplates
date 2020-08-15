defmodule Bigplates.Core.MenuItem.PortionSize do
  @sizes %{
    small: %{min: 1, max: 8},
    medium: %{min: 9, max: 15},
    large: %{min: 16, max: 25}
  }
  @types [:tray, :per_person]
  @default_increment 5
  @entity "people"

  defstruct ~w[type portion price sale_price description min max increment]a

  def new(fields) do
    struct!(__MODULE__, fields)
    |> validate_price_type()
    |> set_range()
    |> generate_description(@entity)
  end

  def update(portion_size, fields) do
    new_portion_size = fields |> new()

    portion_size |> Map.merge(new_portion_size)
  end

  defp set_range(%{type: :tray, portion: portion, min: min, max: max} = portion_size)
       when is_nil(min) and is_nil(max) do
    %{min: min, max: max} = @sizes |> Map.get(portion)

    portion_size
    |> Map.put(:min, min)
    |> Map.put(:max, max)
  end

  defp set_range(%{type: :per_person, increment: increment} = portion_size)
       when is_nil(increment) do
    portion_size
    |> Map.put(:increment, @default_increment)
  end

  defp set_range(portion_size), do: portion_size

  def get_range(size) when is_atom(size), do: @sizes |> Map.get(size)

  def generate_description(%{type: :tray} = portion_size, entity) do
    description = "#{portion_size.portion}: #{portion_size.min} - #{portion_size.max} #{entity}"

    portion_size |> Map.put(:description, description)
  end

  def generate_description(%{type: :per_person} = portion_size, _entity) do
    portion_size |> Map.put(:description, "")
  end

  defp validate_price_type(%{type: price_type} = menu_item) when price_type in @types do
    menu_item
  end
end
