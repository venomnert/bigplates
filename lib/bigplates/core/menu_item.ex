defmodule Bigplates.Core.MenuItem do

  @price_types [:single, :per_person]

  defstruct name: nil,
            description: nil,
            price_type: nil,
            img: [],
            portion_sizes: [],
            published: true,
            variants: []

  def create(fields) do
    struct!(__MODULE__, fields)
  end

  def add_variant(menu_item, fields) do

  end
end
