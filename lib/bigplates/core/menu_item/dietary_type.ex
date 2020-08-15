defmodule Bigplates.Core.MenuItem.DietaryType do
  defstruct halal: false,
            egg_free: false,
            dairy_free: false,
            vegan: false,
            gluten_free: false,
            nut_free: false,
            vegetarian: false

  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
