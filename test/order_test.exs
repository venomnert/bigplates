defmodule OrderTest do
  use ExUnit.Case
  use BigplatesBuilder

  @default_order_requirement %{minimum_time: 0, minimum_order: 0}
  @default_delivery_requirement %{fee: 0, waive_after: 0}

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

  defp order(context) do
    order = order_fields() |> Order.new()

    {:ok, Map.put(context, :order, order)}
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
