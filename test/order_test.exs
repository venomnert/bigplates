defmodule OrderTest do
  use ExUnit.Case
  use BigplatesBuilder

  @default_order_requirement %{minimum_time: 0, minimum_order: 0}
  @default_delivery_requirement %{fee: 0, waive_after: 0}

  describe "CRUD simple order items" do
    test "Add simple order items" do
      order_1 = order_fields()

      restaurant_1 = restaurant_fields() |> Restaurant.new()
      restaurant_2 = restaurant_fields(%{name: "gabbys"}) |> Restaurant.new()

      menu_item_1 = menu_items_fields() |> MenuItem.new()
      menu_item_2 =
        menu_items_fields(%{
          name: "pancakes",
          categories: [:lunch, :dinner],
          description: "Fluffy, delicious, crunchy pancakes with Canadian maple syrup."
        })
        |> MenuItem.new()

      order_item_1 = {restaurant_1, menu_item_1}
      order_item_2 = {restaurant_1, menu_item_2}
      order_item_3 = {restaurant_2, menu_item_2}

      order_1
      |> Order.new()
      |> Order.add_order_item(order_item_1)
      |> assert_order_item_add(order_item_1, 1)
      |> Order.add_order_item(order_item_1)
      |> assert_order_item_add(order_item_1, 2)
      |> Order.add_order_item(order_item_2)
      |> assert_order_item_add(order_item_2, 1)
      |> Order.add_order_item(order_item_3)
      |> Order.add_order_item(order_item_3)
      |> assert_order_item_add(order_item_3, 2)
    end

    test "Reduce simple order items" do
      order_1 = order_fields()

      restaurant_1 = restaurant_fields() |> Restaurant.new()
      restaurant_2 = restaurant_fields(%{name: "gabbys"}) |> Restaurant.new()

      menu_item_1 = menu_items_fields() |> MenuItem.new()
      menu_item_2 =
        menu_items_fields(%{
          name: "pancakes",
          categories: [:lunch, :dinner],
          description: "Fluffy, delicious, crunchy pancakes with Canadian maple syrup."
        })
        |> MenuItem.new()

      order_item_1 = {restaurant_1, menu_item_1}
      order_item_2 = {restaurant_1, menu_item_2}
      order_item_3 = {restaurant_2, menu_item_2}

      order_1
      |> Order.new()
      |> Order.add_order_item(order_item_1)
      |> Order.add_order_item(order_item_1)
      |> Order.add_order_item(order_item_1)
      |> Order.add_order_item(order_item_2)
      |> Order.add_order_item(order_item_3)
      |> Order.add_order_item(order_item_3)
      |> assert_order_item_add(order_item_3, 2)
      |> Order.reduce_order_item(order_item_1)
      |> assert_order_item_add(order_item_1, 2)
      |> Order.reduce_order_item(order_item_2)
      |> assert_order_item_removal(order_item_1)
    end

    test "Remove simple order item" do
      order_1 = order_fields()

      restaurant_1 = restaurant_fields() |> Restaurant.new()
      restaurant_2 = restaurant_fields(%{name: "gabbys"}) |> Restaurant.new()

      menu_item_1 = menu_items_fields() |> MenuItem.new()
      menu_item_2 = menu_items_fields(%{
                      name: "pancakes",
                      categories: [:lunch, :dinner],
                      description: "Fluffy, delicious, crunchy pancakes with Canadian maple syrup.",
                    })
                    |> MenuItem.new()

      order_item_1 = {restaurant_1, menu_item_1}
      order_item_2 = {restaurant_1, menu_item_2}

      order_1
      |> Order.new()
      |> Order.add_order_item(order_item_1)
      |> Order.add_order_item(order_item_1)
      |> Order.add_order_item(order_item_1)
      |> Order.add_order_item(order_item_2)
      |> Order.add_order_item(order_item_2)
      |> assert_order_item_add(order_item_2, 2)
      |> Order.remove_order_item(order_item_1)
      |> assert_order_item_removal(order_item_1)
      |> assert_order_item_add(order_item_2, 2)
      |> Order.remove_order_item(order_item_2)
      |> assert_order_item_removal(order_item_2)

    end
  end

  defp order(context) do
    order = order_fields() |> Order.new()

    {:ok, Map.put(context, :order, order)}
  end

  defp assert_order_item_add(order, order_item, qty) do
    assert Map.get(order.total_items, order_item) == qty
    order
  end

  defp assert_order_item_removal(order, order_item) do
    assert Enum.member?(order.total_items, order_item) == false
    order
  end
end
