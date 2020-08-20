defmodule ComboItemTest do
  use ExUnit.Case
  use BigplatesBuilder

  describe "create & update combo item" do
    test "create combo item" do
      combo_item_field = combo_items_fields()

      combo_item_field
      |> ComboItem.new()
      |> assert_combo_item(combo_item_field)
    end

    test "update combo item" do
      combo_item_field_1 = combo_items_fields()

      combo_item_field_2 =
        combo_items_fields(%{
          name: "Special for 5 Chicken",
          description: "MMMMMM shake",
          price: 70
        })

      combo_item_field_1
      |> ComboItem.new()
      |> assert_combo_item(combo_item_field_1)
      |> ComboItem.update_combo_item(combo_item_field_2)
      |> assert_combo_item(combo_item_field_2)
    end
  end

  describe "CRUD menu items" do
    setup [:combo_item_base]

    test "add menu item", %{combo_item: combo_item} do
      menu_item = menu_items_fields() |> MenuItem.new()

      combo_item
      |> ComboItem.add_menu_item(menu_item)
      |> assert_new_menu_item(menu_item)
    end

    test "increase existing menu item qty", %{combo_item: combo_item} do
      menu_item_1 = menu_items_fields() |> MenuItem.new()

      combo_item
      |> ComboItem.add_menu_item(menu_item_1)
      |> assert_new_menu_item(menu_item_1)
      |> ComboItem.update_menu_item({:increase, menu_item_1})
      |> assert_menu_item(menu_item_1, 2)
    end

    test "increase unknown menu item qty", %{combo_item: combo_item} do
      menu_item_1 = menu_items_fields() |> MenuItem.new()
      menu_item_2 = menu_items_fields(%{name: "Smokey Ribs", description: "Austins famous ribs"}) |> MenuItem.new()

      combo_item
      |> ComboItem.add_menu_item(menu_item_1)
      |> assert_new_menu_item(menu_item_1)
      |> ComboItem.update_menu_item({:increase, menu_item_1})
      |> assert_menu_item(menu_item_1, 2)
      |> ComboItem.update_menu_item({:increase, menu_item_2})
      |> assert_unknown_menu_item(menu_item_2)
    end

    test "decrease menu item qty", %{combo_item: combo_item} do
      menu_item_1 = menu_items_fields() |> MenuItem.new()

      combo_item
      |> ComboItem.add_menu_item(menu_item_1)
      |> assert_new_menu_item(menu_item_1)
      |> ComboItem.update_menu_item({:increase, menu_item_1})
      |> assert_menu_item(menu_item_1, 2)
      |> ComboItem.update_menu_item({:decrease, menu_item_1})
      |> assert_menu_item(menu_item_1, 1)
      |> ComboItem.update_menu_item({:decrease, menu_item_1})
      |> assert_menu_item_removal(menu_item_1)
    end

    test "decrease menu item qty with other items", %{combo_item: combo_item} do
      menu_item_1 = menu_items_fields() |> MenuItem.new()
      menu_item_2 = menu_items_fields(%{name: "Smokey Ribs", description: "Austins famous ribs"}) |> MenuItem.new()

      combo_item
      |> ComboItem.add_menu_item(menu_item_1)
      |> assert_new_menu_item(menu_item_1)
      |> ComboItem.add_menu_item(menu_item_2)
      |> assert_new_menu_item(menu_item_2)
      |> ComboItem.update_menu_item({:increase, menu_item_1})
      |> assert_menu_item(menu_item_1, 2)
      |> ComboItem.update_menu_item({:decrease, menu_item_1})
      |> assert_menu_item(menu_item_1, 1)
      |> ComboItem.update_menu_item({:decrease, menu_item_1})
      |> assert_menu_item_removal(menu_item_1)
      |> assert_new_menu_item(menu_item_2)
    end

    test "remove menu item", %{combo_item: combo_item} do
      menu_item_1 = menu_items_fields() |> MenuItem.new()
      menu_item_2 = menu_items_fields(%{name: "Smokey Ribs", description: "Austins famous ribs"}) |> MenuItem.new()

      combo_item
      |> ComboItem.add_menu_item(menu_item_1)
      |> assert_new_menu_item(menu_item_1)
      |> ComboItem.add_menu_item(menu_item_2)
      |> assert_new_menu_item(menu_item_2)
      |> ComboItem.remove_menu_item(menu_item_2)
      |> assert_menu_item_removal(menu_item_2)
      |> ComboItem.remove_menu_item(menu_item_1)
      |> assert_menu_item_removal(menu_item_1)
    end
  end

  # Automatica saving calculator will be setup sometime in the future

  # describe "calculate savings" do
  #   setup [:combo_item_base]

  #   test "check default savings", %{combo_item: combo_item} do
  #     combo_item
  #     |> assert_savings(nil)
  #   end

  #   test "check savings", %{combo_item: combo_item} do
  #     menu_item = menu_items_fields() |> MenuItem.new()

  #     combo_item
  #     |> ComboItem.add_menu_item(menu_item)
  #     |> assert_new_menu_item(menu_item)
  #     |> ComboItem.calculate_savings()
  #   end
  # end

  defp combo_item_base(context) do
    combo_item = combo_items_fields() |> ComboItem.new()

    {:ok, Map.put(context, :combo_item, combo_item)}
  end

  defp assert_combo_item(combo_item, fields) do
    assert combo_item.name == fields.name
    assert combo_item.description == fields.description
    assert combo_item.price == fields.price
    assert combo_item.savings == fields.savings
    combo_item
  end

  defp assert_new_menu_item(combo_item, menu_item) do
    key = menu_item.name |> String.to_atom()
    assert Keyword.has_key?(combo_item.menu_items, key) == true

    {_, qty} = Keyword.get(combo_item.menu_items, key)
    assert qty == 1

    combo_item
  end

  defp assert_menu_item(combo_item, menu_item, amount) do
    key = menu_item.name |> String.to_atom()
    assert Keyword.has_key?(combo_item.menu_items, key) == true

    {_, qty} = Keyword.get(combo_item.menu_items, key)
    assert qty == amount

    combo_item
  end

  defp assert_menu_item_removal(combo_item, menu_item) do
    key = menu_item.name |> String.to_atom()
    assert Keyword.has_key?(combo_item.menu_items, key) == false
    combo_item
  end

  defp assert_unknown_menu_item(combo_item, menu_item) do
    key = menu_item.name |> String.to_atom()
    assert Keyword.has_key?(combo_item.menu_items, key) == false
    combo_item
  end

  # defp assert_savings(combo_item, amount) do
  #   assert combo_item.savings == amount
  #   combo_item
  # end
end
