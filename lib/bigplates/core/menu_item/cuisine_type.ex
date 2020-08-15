defmodule Bigplates.Core.MenuItem.CuisineType do
  defstruct sri_lankan: false,
            indian: false,
            caribbean: false,
            thai: false,
            filipino: false,
            greek: false,
            italian: false,
            vegan: false,
            canadian: false

  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
