defmodule Bigplates.Core.MenuItem do
  @price_types [:single, :per_person]

  alias Bigplates.Core.{PortionSize, Variant}

  defstruct name: nil,
            description: nil,
            price_type: nil,
            published: true,
            img: [],
            portion_sizes: %{},
            variants: []

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  def add_portion_size(menu_item, fields) do
    portion_size = PortionSize.new(fields)

    menu_item |> Map.put(portion_size.name, portion_size)
  end

  def add_variant(menu_item, {variant_fields, variant_items}) do
    updated_variants = [Variant.new({variant_fields, variant_items})] ++ menu_item.variants

    menu_item |> Map.put(:variants, updated_variants)
  end
end
