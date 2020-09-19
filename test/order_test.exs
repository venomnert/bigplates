defmodule OrderTest do
  use ExUnit.Case
  use BigplatesBuilder

  describe "CRUD simple menu items" do
    test "Add simple menu items" do
      order_1 = order_fields()
      menu_item_1 = menu_items_fields() |> MenuItem.new()
      menu_item_2 = menu_items_fields(%{
                      name: "pancakes",
                      categories: [:lunch, :dinner],
                      description: "Fluffy, delicious, crunchy pancakes with Canadian maple syrup.",
                    })
                    |> MenuItem.new()

      order_1
      |> Order.new()
      |> Order.add_item(menu_item_1)
      |> assert_menu_item(menu_item_1)
      |> Order.add_item(menu_item_2)
      |> assert_menu_item(menu_item_2)
    end

    test "Delete simple menu items" do
      order_1 = order_fields()
      menu_item_1 = menu_items_fields() |> MenuItem.new()
      menu_item_2 = menu_items_fields(%{
                      name: "pancakes",
                      categories: [:lunch, :dinner],
                      description: "Fluffy, delicious, crunchy pancakes with Canadian maple syrup.",
                    })
                    |> MenuItem.new()

      order_1
      |> Order.new()
      |> Order.add_item(menu_item_1)
      |> assert_menu_item(menu_item_1)
      |> Order.add_item(menu_item_2)
      |> assert_menu_item(menu_item_2)
      |> Order.delete_item(menu_item_1)
      |> assert_menu_item_removal(menu_item_1)
      |> assert_menu_item(menu_item_2)
    end
  end

  defp assert_menu_item(order, menu_item) do
    assert Enum.member?(order.total_items, menu_item) == true
    order
  end
  defp assert_menu_item_removal(order, menu_item) do
    assert Enum.member?(order.total_items, menu_item) == false
    order
  end
end
