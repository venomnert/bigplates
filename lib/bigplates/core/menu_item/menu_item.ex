defmodule Bigplates.Core.MenuItem do
  @meal_categories ~w[breakfast lunch dinner]a

  alias Bigplates.Core.MenuItem.{PortionSize, Variant, CuisineType, DietaryType}

  defstruct name: nil,
            description: nil,
            categories: [],
            cuisine_type: %CuisineType{},
            dietary_type: %DietaryType{},
            portion_sizes: %{},
            variants: %{},
            extra: "",
            img: [],
            hidden: false

  def new(%{categories: categories} = fields) do
    struct!(__MODULE__, fields)
    |> validate_categories()
  end

  def update_menu_item(menu_item, fields) do
    new_menu_item = fields |> new()
    menu_item |> Map.merge(new_menu_item)
  end

  def update_cuisine_type(menu_item, %CuisineType{} = cuisine_type) do
    menu_item |> Map.put(:cuisine_type, cuisine_type)
  end

  def update_dietary_type(menu_item, %DietaryType{} = dietary_type) do
    menu_item |> Map.put(:dietary_type, dietary_type)
  end

  def update_extra(menu_item, text) do
    menu_item |> Map.put(:extra, text)
  end

  def add_portion_size(menu_item, %PortionSize{} = portion_size) do
    updated_portion_sizes =
      menu_item.portion_sizes |> Map.put(portion_size.portion, portion_size)

    menu_item |> Map.put(:portion_sizes, updated_portion_sizes)
  end

  def update_portion_size(menu_item, %PortionSize{} = old_portion_size, new_portion_size_fields) do
    updated_portion_size =
      menu_item.portion_sizes
      |> Map.get(old_portion_size.portion)
      |> PortionSize.update(new_portion_size_fields)

    updated_portion_sizes =
      menu_item.portion_sizes
      |> Map.delete(old_portion_size.portion)
      |> Map.put(updated_portion_size.portion, updated_portion_size)

    menu_item |> Map.put(:portion_sizes, updated_portion_sizes)
  end

  def delete_portion_size(menu_item, portion_size) do
    updated_portion_sizes = menu_item.portion_sizes |> Map.delete(portion_size.portion)
    menu_item |> Map.put(:portion_sizes, updated_portion_sizes)
  end

  def add_variant(menu_item, %Variant{} = variant) do
    updated_variants = menu_item.variants |> Map.put(variant.name, variant)
    menu_item |> Map.put(:variants, updated_variants)
  end

  def update_variant(menu_item, variant, new_variant) do
    updated_variant =
      menu_item.variants
      |> Map.get(variant.name)
      |> Variant.update(new_variant)

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

  def add_variant_option(menu_item, variant, new_variant_options) do
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

  def validate_categories(menu_item) do
    updated_categories = menu_item.categories
                          |> Enum.filter(&is_category_valid(&1))

    Map.put(menu_item, :categories, updated_categories)
  end

  defp is_category_valid(category), do: category in @meal_categories

end
