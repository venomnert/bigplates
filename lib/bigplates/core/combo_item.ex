defmodule Bigplates.Core.ComboItem do

  defstruct name: nil,
            price: nil,
            sale_price: nil,
            description: nil,
            cutlery: false,
            published: true,
            menu_items: [],
            img: [],
            portion_sizes: [],
            variants: []

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  def add_variant(combo_item, fields) do
  end

  def add_menu_item(combo_item, fields) do
  end
end
