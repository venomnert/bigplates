defmodule Bigplates.Core.PortionSize do


  """
    1. small: 1 - 8 people
    2. medium: 8 - 15 people
    3. large: 15 - 25 people
  """

  defstruct ~w[name price sale_price min max min_order description]a

  def new(fields) do
    struct!(__MODULE__, fields)
    |> generate_description("people")
  end


  defp generate_description(portion_size, entity) do
    description = "#{portion_size.name}: #{portion_size.min} - #{portion_size.max} #{entity}"

    portion_size |> Map.put(:description, description)
  end

end

