defmodule Bigplates.Core.ComboItem do
  alias Bigplates.Core.{MenuItem, PortionSize, Variant}

  defstruct name: nil,
            price: nil,
            sale_price: nil,
            description: nil,
            cutlery: false,
            published: true,
            menu_items: [],
            portion_sizes: %{},
            variants: [],
            img: []

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  def add_menu_item(combo_item, %MenuItem{} = menu_item) do
    updated_menu = [menu_item] ++ combo_item.menu_items

    combo_item |> Map.put(:menu_items, updated_menu)
  end

  def add_portion_size(combo_item, fields) do
    portion_size = PortionSize.new(fields)

    combo_item |> Map.put(portion_size.name, portion_size)
  end

  def add_variant(combo_item, {variant_fields, variant_options}) do
    updated_variants = [Variant.new({variant_fields, variant_options})] ++ combo_item.variants

    combo_item |> Map.put(:variants, updated_variants)
  end
end
