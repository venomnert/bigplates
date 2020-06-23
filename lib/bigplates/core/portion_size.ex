defmodule Bigplates.Core.PortionSize do
  @sizes %{
    small: %{min: 1, max: 8},
    medium: %{min: 9, max: 15},
    large: %{min: 16, max: 25}
  }
  @entity "people"

  defstruct ~w[name price sale_price description min max]a

  def new(fields) do
    struct!(__MODULE__, fields)
    |> set_range()
    |> generate_description(@entity)
  end

  def update(portion_size, fields) do
    new_portion_size = fields |> new()

    portion_size |> Map.merge(new_portion_size)
  end

  defp set_range(%{name: name} = portion_size) do
    %{min: min, max: max} = @sizes |> Map.get(name)
    portion_size |> Map.put(:min, min) |> Map.put(:max, max)
  end

  def get_range(size) when is_atom(size), do: @sizes |> Map.get(size)

  def generate_description(portion_size, entity) do
    description = "#{portion_size.name}: #{portion_size.min} - #{portion_size.max} #{entity}"

    portion_size |> Map.put(:description, description)
  end
end
