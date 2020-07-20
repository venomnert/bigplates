defmodule Bigplates.Core.MenuItem do
  @price_types [:single, :per_person]
  @meal_categories ~w[breakfast lunch dinner]a

  alias Bigplates.Core.{PortionSize, Variant}

  defstruct name: nil,
            category: nil,
            description: nil,
            price_type: nil,
            portion_sizes: %{},
            variants: %{},
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

  def update_portion_size(
        menu_item,
        %PortionSize{name: to_update} = old_portion_size,
        new_portion_size
      ) do
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

  def add_variant(menu_item, {variant_fields, variant_options}) do
    new_variant = Variant.new({variant_fields, variant_options})
    updated_variants = menu_item.variants |> Map.put(new_variant.name, new_variant)

    menu_item |> Map.put(:variants, updated_variants)
  end

  def update_variant(menu_item, variant, new_variant) do
    updated_variant = menu_item.variants |> Map.get(variant.name) |> Variant.update(new_variant)

    updated_variants =
      menu_item.variants
      |> Map.delete(variant.name)
      |> Map.put(updated_variant.name, updated_variant)

    menu_item |> Map.put(:variants, updated_variants)
  end

  def remove_variant(menu_item, variant) do
    updated_variants =
      menu_item.variants
      |> Map.delete(variant.name)

    menu_item |> Map.put(:variants, updated_variants)
  end

  def find_variant_index(variants, %{name: name} = variant) do
    variants
    |> Enum.find_index(&(&1.name == name))
  end

  def add_variant_option(menu_item, {variant, new_variant_options}) do
    updated_variants =
      menu_item.variants
      |> Map.update(variant.name, nil, &Variant.add_variant_option(&1, new_variant_options))

    menu_item |> Map.put(:variants, updated_variants)
  end

  def update_variant_option(menu_item, {variant, new_variant_options}) do
    updated_variants =
      menu_item.variants
      |> Map.update(variant.name, nil, &Variant.add_variant_option(&1, new_variant_options))

    menu_item |> Map.put(:variants, updated_variants)
  end

  def remove_variant_option(menu_item, variant, variant_option) do
    updated_variants =
      menu_item.variants
      |> Map.update(variant.name, nil, &Variant.remove_variant_option(&1, variant_option))

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
