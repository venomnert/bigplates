defmodule MenuItemTest do
  use ExUnit.Case
  use BigplatesBuilder

  describe "create & update menu item" do
    test "create menu item" do
      menu_item_field = menu_items_fields()

      menu_item_field
      |> MenuItem.new()
      |> assert_menu_item(menu_item_field)
    end

    test "update menu item" do
      menu_item_field_1 = menu_items_fields()

      menu_item_field_2 =
        menu_items_fields(%{
          name: "Protein shake",
          description: "MMMMMM shake",
        })

      menu_item_field_1
      |> MenuItem.new()
      |> assert_menu_item(menu_item_field_1)
      |> MenuItem.update_menu_item(menu_item_field_2)
      |> assert_menu_item(menu_item_field_2)
    end
  end

  describe "adding cuisine type" do
    setup [:menu_item_base]

    test "update cuisine type", %{menu_item: menu_item} do
      cuisine_type_1 = cuisine_fields() |> CuisineType.new()

      cuisine_type_2 =
        cuisine_fields(%{
          filipino: false,
          greek: false,
          italian: false,
          sri_lankan: true,
          indian: true
        })
        |> CuisineType.new()

      menu_item
      |> MenuItem.update_cuisine_type(cuisine_type_1)
      |> assert_cuisine_type(cuisine_type_1)
      |> MenuItem.update_cuisine_type(cuisine_type_2)
      |> assert_cuisine_type(cuisine_type_2)
    end
  end

  describe "adding dietary type" do
    setup [:menu_item_base]

    test "update dietary type", %{menu_item: menu_item} do
      dietary_type_1 = dietary_fields() |> DietaryType.new()

      dietary_type_2 =
        dietary_fields(%{
          egg_free: false,
          vegetarian: false,
          gluten_free: true,
          nut_free: true,
        })
        |> DietaryType.new()

      menu_item
      |> MenuItem.update_dietary_type(dietary_type_1)
      |> assert_dietary_type(dietary_type_1)
      |> MenuItem.update_dietary_type(dietary_type_2)
      |> assert_dietary_type(dietary_type_2)
    end
  end

  describe "CRUD portion sizes" do
    setup [:menu_item_base]

    test "add portion sizes to menu item", %{menu_item: menu_item} do
      portion_size_1 = portion_size_fields() |> PortionSize.new()
      portion_size_2 = portion_size_fields(%{portion: :medium, sale_price: 10}) |> PortionSize.new()
      portion_size_3 = portion_size_fields(%{type: :per_person, price: 10}) |> PortionSize.new()

      menu_item
      |> MenuItem.add_portion_size(portion_size_1)
      |> assert_portion_size(portion_size_1)
      |> MenuItem.add_portion_size(portion_size_2)
      |> assert_portion_size(portion_size_2)
      |> MenuItem.add_portion_size(portion_size_3)
      |> assert_portion_size(portion_size_3)
    end

    test "create reduntant portion sizes to menu item", %{menu_item: menu_item} do
      portion_size_1 = portion_size_fields() |> PortionSize.new()
      portion_size_2 = portion_size_fields(%{price: 10}) |> PortionSize.new()

      menu_item
      |> MenuItem.add_portion_size(portion_size_1)
      |> MenuItem.add_portion_size(portion_size_2)
      |> assert_portion_size(portion_size_2)
      |> assert_portion_size_count(1)
    end

    test "update portion sizes to menu item", %{menu_item: menu_item} do
      portion_size_1 = portion_size_fields(%{portion: :medium}) |> PortionSize.new()
      portion_size_2 = portion_size_fields(%{type: :per_person, price: 30, sale_price: 10}) |> PortionSize.new()
      new_portion_size_fields = portion_size_fields(%{type: :per_person, price: 30, sale_price: 10})

      menu_item
      |> MenuItem.add_portion_size(portion_size_1)
      |> assert_portion_size(portion_size_1)
      |> MenuItem.update_portion_size(portion_size_1, new_portion_size_fields)
      |> assert_portion_size(portion_size_2)
      |> assert_portion_size_count(1)
    end

    test "remove portion sizes to menu item", %{menu_item: menu_item} do
      portion_size_1 = portion_size_fields() |> PortionSize.new()

      menu_item
      |> MenuItem.add_portion_size(portion_size_1)
      |> assert_portion_size(portion_size_1)
      |> assert_portion_size_count(1)
      |> MenuItem.delete_portion_size(portion_size_1)
      |> assert_portion_size_count(0)
    end
  end

  describe "CRUD variants" do
    setup [:menu_item_base]

    test "add variant to menu item", %{menu_item: menu_item} do
      variant_1_fields = variant_fields(%{name: "Toppings", type: :multiple, max_options: 1})
      variant_1_options = [
        VariantOption.new(variant_option_fields(%{name: "Tomatoes", price: 0, description: ""})),
        VariantOption.new(variant_option_fields(%{name: "Onion", price: 0, description: ""}))
      ]
      variant_1 = Variant.new({variant_1_fields, variant_1_options})

      variant_2_fields = variant_fields(%{name: "Doneness", type: :multiple, max_options: 1})
      variant_2_options = [
        VariantOption.new(variant_option_fields(%{name: "Rare",price: 0,description: "Bleeding good."})),
        VariantOption.new(variant_option_fields(%{name: "Medium Rare",price: 0,description: "Just enough bleeding."})),
        VariantOption.new(variant_option_fields(%{name: "Well done.",price: 0,description: "Warning potential choking hazard. Get yourself a nurse girlfriend."}))
      ]
      variant_2 = Variant.new({variant_2_fields, variant_2_options})

      menu_item
      |> MenuItem.add_variant(variant_1)
      |> assert_variant(variant_1)
      |> MenuItem.add_variant(variant_2)
      |> assert_variant(variant_2)
    end

    test "update variant to menu item", %{menu_item: menu_item} do
      variant_1_fields = variant_fields(%{name: "Toppings", type: :multiple, max_options: 1})
      variant_1_options = [
        VariantOption.new(variant_option_fields(%{name: "Tomatoes", price: 0, description: ""})),
        VariantOption.new(variant_option_fields(%{name: "Onion", price: 0, description: ""}))
      ]
      variant_1 = Variant.new({variant_1_fields, variant_1_options})

      variant_2_fields = variant_fields(%{name: "Doneness", type: :multiple, max_options: 1})
      variant_2_options = [
        VariantOption.new(variant_option_fields(%{name: "Rare",price: 0,description: "Bleeding good."})),
        VariantOption.new(variant_option_fields(%{name: "Medium Rare",price: 0,description: "Just enough bleeding."})),
        VariantOption.new(variant_option_fields(%{name: "Well done.",price: 0,description: "Warning potential choking hazard. Get yourself a nurse girlfriend."}))
      ]
      variant_2 = Variant.new({variant_2_fields, variant_2_options})

      variant_3_fields =
        variant_fields(%{name: "Sides", type: :multiple, max_options: 4, required: false})

      variant_3 = Variant.new({variant_3_fields, variant_2_options})

      menu_item
      |> MenuItem.add_variant(variant_1)
      |> MenuItem.add_variant(variant_2)
      |> assert_variant(variant_2)
      |> MenuItem.update_variant(variant_2, variant_3_fields)
      |> assert_variant(variant_3)
    end

    test "remove variant to menu item", %{menu_item: menu_item} do
      variant_1_fields = variant_fields(%{name: "Toppings", type: :multiple, max_options: 1})
      variant_1_options = [
        VariantOption.new(variant_option_fields(%{name: "Tomatoes", price: 0, description: ""})),
        VariantOption.new(variant_option_fields(%{name: "Onion", price: 0, description: ""}))
      ]
      variant_1 = Variant.new({variant_1_fields, variant_1_options})

      variant_2_fields = variant_fields(%{name: "Doneness", type: :multiple, max_options: 1})
      variant_2_options = [
        VariantOption.new(variant_option_fields(%{name: "Rare",price: 0,description: "Bleeding good."})),
        VariantOption.new(variant_option_fields(%{name: "Medium Rare",price: 0,description: "Just enough bleeding."})),
        VariantOption.new(variant_option_fields(%{name: "Well done.",price: 0,description: "Warning potential choking hazard. Get yourself a nurse girlfriend."}))
      ]
      variant_2 = Variant.new({variant_2_fields, variant_2_options})

      menu_item
      |> MenuItem.add_variant(variant_1)
      |> MenuItem.add_variant(variant_2)
      |> MenuItem.remove_variant(variant_2)
      |> assert_variant_removed(variant_2)
    end
  end

  describe "CRD variant options" do
    setup [:menu_item_base]

    test "add variant option", %{menu_item: menu_item} do
      variant_1_fields = variant_fields(%{name: "Toppings", type: :multiple, max_options: 1})
      variant_1_options = [
        VariantOption.new(variant_option_fields(%{name: "Tomatoes", price: 0, description: ""})),
        VariantOption.new(variant_option_fields(%{name: "Onion", price: 0, description: ""}))
      ]
      variant_1 = Variant.new({variant_1_fields, variant_1_options})

      new_options = [
        VariantOption.new(variant_option_fields(%{name: "Sausage", price: 1, description: "extra spicy sausage"})),
        VariantOption.new(variant_option_fields(%{name: "Meat", price: 5, description: "extra meat!!!!!"}))
      ]
      variant_2 = Variant.new({variant_1_fields, variant_1_options ++ new_options})

      menu_item
      |> MenuItem.add_variant(variant_1)
      |> assert_variant(variant_1)
      |> MenuItem.add_variant_option(variant_1, new_options)
      |> assert_variant(variant_2)
    end

    test "remove variant option to menu item", %{menu_item: menu_item} do
      variant_1_fields = variant_fields(%{name: "Doneness", type: :multiple, max_options: 3})
      variant_1_options = [
        VariantOption.new(variant_option_fields(%{
          name: "Rare",
          price: 0,
          description: "Bleeding good."
        })),
        VariantOption.new(variant_option_fields(%{name: "Medium Rare",price: 0,description: "Just enough bleeding."})),
        VariantOption.new(variant_option_fields(%{name: "Well done.",price: 0,description: "Warning potential choking hazard. Get yourself a nurse girlfriend."}))
      ]
      variant_1 = Variant.new({variant_1_fields, variant_1_options})

      new_options = [
        VariantOption.new(variant_option_fields(%{name: "Sausage", price: 1, description: "extra spicy sausage"})),
        VariantOption.new(variant_option_fields(%{name: "Meat", price: 5, description: "extra meat!!!!!"}))
      ]

      menu_item
      |> MenuItem.add_variant(variant_1)
      |> MenuItem.add_variant_option(variant_1, new_options)
      |> MenuItem.remove_variant_option(variant_1, %{
        name: "Rare",
        price: 0,
        description: "Bleeding good."
      })
      |> assert_variant_option_removed(variant_1, %{
        name: "Rare",
        price: 0,
        description: "Bleeding good."
      })
    end
  end

  describe "add extras" do
    setup [:menu_item_base]

    test "add extras", %{menu_item: menu_item} do
      text_1 = "Add more ketchup please"
      text_2 = "Make it spicy please"

      menu_item
      |> MenuItem.update_extra(text_1)
      |> assert_extra(text_1)
      |> MenuItem.update_extra(text_2)
      |> assert_extra(text_2)
    end
  end

  defp menu_item_base(context) do
    menu_item = menu_items_fields() |> MenuItem.new()

    {:ok, Map.put(context, :menu_item, menu_item)}
  end

  defp assert_menu_item(menu_item, fields) do
    assert menu_item.name == fields.name
    assert menu_item.description == fields.description
    assert menu_item.category == fields.category
    menu_item
  end

  defp assert_extra(menu_item, text) do
    assert menu_item.extra == text
    menu_item
  end

  defp assert_cuisine_type(menu_item, cuisine_type) do
    assert menu_item.cuisine_type == cuisine_type
    menu_item
  end

  defp assert_dietary_type(menu_item, dietary_type) do
    assert menu_item.dietary_type == dietary_type
    menu_item
  end

  defp assert_portion_size(menu_item, portion_size) do
    assert Map.has_key?(menu_item.portion_sizes, portion_size.portion) == true
    menu_item
  end

  defp assert_portion_size_count(menu_item, count) when count == 0 do
    portion_sizes_count = menu_item.portion_sizes |> Map.keys() |> Enum.empty?()
    assert portion_sizes_count == true
    menu_item
  end

  defp assert_portion_size_count(menu_item, count) do
    portion_sizes_count = menu_item.portion_sizes |> Map.keys() |> length()
    assert portion_sizes_count == count
    menu_item
  end

  defp assert_variant(menu_item, %{name: name, options: options} = variant) do
    assert Map.get(menu_item.variants, name).name == variant.name
    assert Map.get(menu_item.variants, name).required == variant.required
    assert Map.get(menu_item.variants, name).type == variant.type
    assert Map.get(menu_item.variants, name).options == options

    menu_item
  end

  defp assert_variant_removed(menu_item, variant) do
    assert Enum.member?(menu_item.variants, variant.name) == false
    menu_item
  end

  defp assert_variant_option_removed(menu_item, variant, variant_option) do
    result =
      menu_item.variants
      |> Map.get(variant.name)
      |> Map.get(:options)
      |> Enum.member?(variant_option.name)

    assert result == false
    menu_item
  end
end
