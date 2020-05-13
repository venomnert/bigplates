defmodule Bigplates.Core.PortionSize do

  """
    * serving_range: [lower, higher]

    1. small: 1 - 8 people
    2. medium: 8 - 15 people
    3. large: 15 - 25 people
  """

  defstruct price: nil,
            sale_price: nil,
            name: nil,
            serving_range: [],
            min_order: 1,
            description: nil

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  def generate_description(portion_size, entity) do
    description = "#{portion_size.name}: #{get_min(portion_size)} - #{get_max(portion_size)} #{entity}"

    portion_size |> Map.put(:description, description)
  end

  defp get_min(portion_size), do: portion_size.serving_range |> hd()
  defp get_max(portion_size), do: portion_size.serving_range |> List.last()

end

