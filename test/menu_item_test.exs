defmodule MenuItemTest do
  use ExUnit.Case
  use BigplatesBuilder

  describe "create & update menu item" do
    test "create menu item" do
      menu_item_field = menu_items_fields(%{price_type: :single})

      menu_item_field
      |> MenuItem.new()
      |> assert_menu_item(menu_item_field)
    end

    test "update menu item" do
      menu_item_field_1 = menu_items_fields(%{price_type: :single})

      menu_item_field_2 =
        menu_items_fields(%{
          name: "Protein shake",
          description: "MMMMMM shake",
          price_type: :per_person
        })

      menu_item_field_1
      |> MenuItem.new()
      |> assert_menu_item(menu_item_field_1)
      |> MenuItem.update_menu_item(menu_item_field_2)
      |> assert_menu_item(menu_item_field_2)
    end

    test "update price type" do
      menu_item_field_1 = menu_items_fields(%{price_type: :single})
      menu_item_field_2 = menu_items_fields(%{price_type: :per_person})

      menu_item_field_1
      |> MenuItem.new()
      |> assert_menu_item(menu_item_field_1)
      |> MenuItem.update_menu_item(menu_item_field_2)
      |> assert_menu_item(menu_item_field_2)
    end

    test "invalide price type" do
      menu_item_field_1 = menu_items_fields(%{price_type: :single})
      menu_item_field_2 = menu_items_fields(%{price_type: :something_new})
      invalid_item_field = menu_items_fields(%{price_type: nil})

      menu_item_field_1
      |> MenuItem.new()
      |> assert_menu_item(menu_item_field_1)
      |> MenuItem.update_menu_item(menu_item_field_2)
      |> assert_menu_item(invalid_item_field)
    end
  end

  describe "CRUD portion sizes" do
    setup [:menu_item_base]

    test "add portion sizes to menu item", %{menu_item: menu_item} do
      portion_size_1 = portion_size_fields() |> PortionSize.new()
      portion_size_2 = portion_size_fields(%{name: :medium, sale_price: 10}) |> PortionSize.new()

      menu_item
      |> MenuItem.add_portion_size(portion_size_1)
      |> assert_portion_size(portion_size_1)
      |> MenuItem.add_portion_size(portion_size_2)
      |> assert_portion_size(portion_size_2)
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
      portion_size_1 = portion_size_fields() |> PortionSize.new()
      portion_size_2 = portion_size_fields(%{name: :medium, sale_price: 10})
      updated_portion_size = PortionSize.update(portion_size_1, portion_size_2)

      menu_item
      |> MenuItem.add_portion_size(portion_size_1)
      |> assert_portion_size(portion_size_1)
      |> MenuItem.update_portion_size(portion_size_1, portion_size_2)
      |> assert_portion_size(updated_portion_size)
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
      variant_1 = variant_fields(%{name: "Toppings", type: :multiple, max_options: 1})

      variant_1_options = [
        variant_item_fields(%{name: "Tomatoes", price: 0, description: ""}),
        variant_item_fields(%{name: "Onion", price: 0, description: ""})
      ]

      variant_2 = variant_fields(%{name: "Doneness", type: :multiple, max_options: 1})

      variant_2_options = [
        variant_item_fields(%{
          name: "Rare",
          price: 0,
          description: "Bleeding good."
        }),
        variant_item_fields(%{
          name: "Medium Rare",
          price: 0,
          description: "Just enough bleeding."
        }),
        variant_item_fields(%{
          name: "Well done.",
          price: 0,
          description: "Warning potential choking hazard. Get yourself a nurse girlfriend."
        })
      ]

      menu_item
      |> MenuItem.add_variant({variant_1, variant_1_options})
      |> assert_variant({variant_1, variant_1_options})
      |> MenuItem.add_variant({variant_2, variant_2_options})
      |> assert_variant({variant_2, variant_2_options})
    end

    test "update variant to menu item", %{menu_item: menu_item} do
      variant_1 = variant_fields(%{name: "Toppings", type: :multiple, max_options: 1})
      variant_1_options = [
        variant_item_fields(%{name: "Tomatoes", price: 0, description: ""}),
        variant_item_fields(%{name: "Onion", price: 0, description: ""})
      ]

      variant_2 = variant_fields(%{name: "Doneness", type: :multiple, max_options: 1})
      variant_2_options = [
        variant_item_fields(%{
          name: "Rare",
          price: 0,
          description: "Bleeding good."
        }),
        variant_item_fields(%{
          name: "Medium Rare",
          price: 0,
          description: "Just enough bleeding."
        }),
        variant_item_fields(%{
          name: "Well done.",
          price: 0,
          description: "Warning potential choking hazard. Get yourself a nurse girlfriend."
        })
      ]

      variant_3 =
        variant_fields(%{name: "Sides", type: :multiple, max_options: 4, required: false})

      menu_item
      |> MenuItem.add_variant({variant_1, variant_1_options})
      |> MenuItem.add_variant({variant_2, variant_2_options})
      |> assert_variant({variant_2, variant_2_options})
      |> MenuItem.update_variant(variant_2, variant_3)
      |> assert_variant({variant_3, variant_2_options})
    end

    test "remove variant to menu item", %{menu_item: menu_item} do
      variant_1 = variant_fields(%{name: "Toppings", type: :multiple, max_options: 1})

      variant_1_options = [
        variant_item_fields(%{name: "Tomatoes", price: 0, description: ""}),
        variant_item_fields(%{name: "Onion", price: 0, description: ""})
      ]

      variant_2 = variant_fields(%{name: "Doneness", type: :multiple, max_options: 1})

      variant_2_options = [
        variant_item_fields(%{
          name: "Rare",
          price: 0,
          description: "Bleeding good."
        }),
        variant_item_fields(%{
          name: "Medium Rare",
          price: 0,
          description: "Just enough bleeding."
        }),
        variant_item_fields(%{
          name: "Well done.",
          price: 0,
          description: "Warning potential choking hazard. Get yourself a nurse girlfriend."
        })
      ]

      menu_item
      |> MenuItem.add_variant({variant_1, variant_1_options})
      |> MenuItem.add_variant({variant_2, variant_2_options})
      |> MenuItem.remove_variant(variant_2)
      |> assert_variant_removed({variant_2, variant_2_options})
    end
  end

  describe "CRUD variant items" do
    setup [:menu_item_base]

    test "add variant item", %{menu_item: menu_item} do
      variant_1 = variant_fields(%{name: "Toppings", type: :multiple, max_options: 1})
      variant_1_options = [
        variant_item_fields(%{name: "Tomatoes", price: 0, description: ""}),
        variant_item_fields(%{name: "Onion", price: 0, description: ""})
      ]
      new_options = [
        variant_item_fields(%{name: "Sausage", price: 1, description: "extra spicy sausage"}),
        variant_item_fields(%{name: "Meat", price: 5, description: "extra meat!!!!!"})
      ]

      menu_item
      |> MenuItem.add_variant({variant_1, variant_1_options})
      |> assert_variant({variant_1, variant_1_options})
      |> MenuItem.add_variant_item({variant_1, new_options})
      |> assert_variant({variant_1, variant_1_options ++ new_options})
    end

    test "update variant item", %{menu_item: menu_item} do
      variant_1 = variant_fields(%{name: "Toppings", type: :multiple, max_options: 1})

      variant_1_options = [
        variant_item_fields(%{name: "Tomatoes", price: 0, description: ""}),
        variant_item_fields(%{name: "Onion", price: 0, description: ""})
      ]

      variant_2 = variant_fields(%{name: "Toppings", type: :multiple, max_options: 3})

      new_options = [
        variant_item_fields(%{name: "Tomatoes", price: 0, description: ""}),
        variant_item_fields(%{name: "Onion", price: 0, description: ""}),
        variant_item_fields(%{name: "Sausage", price: 1, description: "extra spicy sausage"}),
        variant_item_fields(%{name: "Meat", price: 5, description: "extra meat!!!!!"})
      ]

      menu_item
      |> MenuItem.add_variant({variant_1, variant_1_options})
      |> assert_variant({variant_1, variant_1_options})
      |> MenuItem.update_variant(variant_1, {variant_2, new_options})
      |> assert_variant({variant_2, new_options})
    end

    test "remove variant to menu item", %{menu_item: menu_item} do
      variant_1 = variant_fields(%{name: "Doneness", type: :multiple, max_options: 3})
      variant_1_options = [
        variant_item_fields(%{
          name: "Rare",
          price: 0,
          description: "Bleeding good."
        }),
        variant_item_fields(%{
          name: "Medium Rare",
          price: 0,
          description: "Just enough bleeding."
        }),
        variant_item_fields(%{
          name: "Well done.",
          price: 0,
          description: "Warning potential choking hazard. Get yourself a nurse girlfriend."
        })
      ]

      new_options = [
        variant_item_fields(%{name: "Sausage", price: 1, description: "extra spicy sausage"}),
        variant_item_fields(%{name: "Meat", price: 5, description: "extra meat!!!!!"})
      ]

      menu_item
      |> MenuItem.add_variant({variant_1, variant_1_options})
      |> MenuItem.add_variant_item({variant_1, new_options})
      |> MenuItem.remove_variant_item(variant_1, %{
        name: "Rare",
        price: 0,
        description: "Bleeding good."
      })
      |> assert_variant_item_removed(variant_1, %{
        name: "Rare",
        price: 0,
        description: "Bleeding good."
      })
    end
  end

  defp menu_item_base(context) do
    menu_item = menu_items_fields(%{price_type: :single}) |> MenuItem.new()

    {:ok, Map.put(context, :menu_item, menu_item)}
  end

  defp add_portion_size(menu_item) do
    portion_size_1 = portion_size_fields() |> PortionSize.new()

    menu_item
    |> MenuItem.add_portion_size(portion_size_1)
  end

  defp assert_menu_item(menu_item, fields) do
    assert fields.name == menu_item.name
    assert fields.description == menu_item.description
    assert fields.price_type == menu_item.price_type
    menu_item
  end

  defp assert_portion_size(menu_item, %PortionSize{name: name}) do
    assert Map.has_key?(menu_item.portion_sizes, name) == true
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

  defp assert_variant(menu_item, {variant_fields, _variant_items}) do
    assert Map.get(menu_item.variants, variant_fields.name) != nil
    assert Map.get(menu_item.variants, variant_fields.name).name == variant_fields.name
    assert Map.get(menu_item.variants, variant_fields.name).required == variant_fields.required
    assert Map.get(menu_item.variants, variant_fields.name).type == variant_fields.type

    menu_item
  end

  defp assert_variant_removed(menu_item, {variant, _variant_options}) do
    result =
      menu_item.variants
      |> Enum.member?(variant.name)

    assert result == false
    menu_item
  end

  defp assert_variant_item_removed(menu_item, variant, variant_item) do
    result =
      menu_item.variants
      |> Map.get(variant.name)
      |> Map.get(:options)
      |> Enum.member?(variant_item.name)

    assert result == false
    menu_item
  end
  
end
