defmodule Bigplates.Core.MenuItem do

  defstruct name: nil,
            price: nil,
            sale_price: nil,
            description: nil,
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
