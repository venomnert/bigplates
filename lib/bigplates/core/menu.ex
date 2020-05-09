defmodule Bigplates.Core.Menu do
  """
    * meal_category: [:breakfast, :lunch, :dinner] - only one allowed
  """

  defstruct name: nil,
            meal_category: nil,
            published: true,
            slug: nil

  def create(fields) do
    struct!(__MODULE__, fields)
  end
end
