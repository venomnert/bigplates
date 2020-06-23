defmodule Bigplates.Core.MenuItem do
  @price_types [:single, :per_person]

  alias Bigplates.Core.{PortionSize, Variant}

  defstruct name: nil,
            description: nil,
            price_type: nil,
            portion_sizes: %{},
            variants: [],
            img: [],
            hidden: true

  def new(fields) do
    struct!(__MODULE__, fields)
    |> validate_price_type()
  end

  def update_menu_item(menu_item, fields) do
    new_menu_item = fields |> new()
    menu_item |> Map.merge(new_menu_item)
  end

  def add_portion_size(menu_item, %PortionSize{} = portion_size) do
    updated_portion_sizes = menu_item.portion_sizes |> Map.put(portion_size.name, portion_size)
    menu_item |> Map.put(:portion_sizes, updated_portion_sizes)
  end

  def update_portion_size(menu_item, %PortionSize{name: to_update} = old_portion_size, new_portion_size) do
    updated_portion_size = old_portion_size |> PortionSize.update(new_portion_size)

    new_menu_item_portion_sizes =
      menu_item.portion_sizes
      |> Map.delete(to_update)
      |> Map.put(updated_portion_size.name, updated_portion_size)

    menu_item |> Map.put(:portion_sizes, new_menu_item_portion_sizes)
  end

  def delete_portion_size(menu_item, %PortionSize{} = portion_size) do
    updated_portion_sizes = menu_item.portion_sizes |> Map.delete(portion_size.name)
    menu_item |> Map.put(:portion_sizes, updated_portion_sizes)
  end

  def add_variant(menu_item, {variant_fields, variant_items}) do
    updated_variants = [Variant.new({variant_fields, variant_items})] ++ menu_item.variants

    menu_item |> Map.put(:variants, updated_variants)
  end

  defp validate_price_type(%{price_type: price_type} = menu_item)
       when price_type in @price_types do
    menu_item
  end

  @doc """
  Invalid price types fails silently and set's the value to nil.
  """
  defp validate_price_type(%{price_type: price_type} = menu_item) do
    menu_item |> Map.put(:price_type, nil)
  end
end
