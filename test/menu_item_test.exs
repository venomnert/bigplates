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
end
