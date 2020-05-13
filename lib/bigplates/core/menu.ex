defmodule Bigplates.Core.Menu do
  alias Bigplates.Utility

  @meal_categories ~w[breakfast lunch dinner]a

  defstruct ~w[name meal_category slug]a

  def new(fields) do
    %__MODULE__{
      name: fields.name,
      meal_category: add_valid_category(fields),
      slug: Utility.create_slug(fields.name)
    }
  end

  def get_meal_categories(), do: @meal_categories

  defp add_valid_category(fields) do
    is_valid_category(fields.meal_category)
    |> case do
      true -> fields.meal_category
      false -> Utility.create_slug(fields.name)
    end
  end

  defp is_valid_category(category) do
    @meal_categories
    |> Enum.member?(category)
  end
end
