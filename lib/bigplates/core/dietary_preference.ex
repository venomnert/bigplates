defmodule Bigplates.Core.DietaryPreference do
  @dietary_preference [:halal, :egg_free, :dairy_free, :vegan, :gluten_free, :nut_free, :vegetarian]

  defstruct name: nil

  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
