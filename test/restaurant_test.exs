defmodule RestaurantTest do
  use ExUnit.Case
  use BigplatesBuilder


  describe "adding & updating restaurant" do
    setup [:restaurant]

    test "Creating new restaurant" do
      restaurant_1 = restaurant_fields()

      restaurant_1
      |> Restaurant.new()
      |> assert_restaurant(restaurant_1)
    end

    test "Update restaurant" do
      restaurant_1 = restaurant_fields()
      restaurant_2 = restaurant_fields(%{name: "Tom", cuisine_name: "Malaysian"})

      restaurant_1
      |> Restaurant.new()
      |> assert_restaurant(restaurant_1)
      |> Restaurant.update_info(restaurant_2)
      |> assert_restaurant(restaurant_2)
    end

    test "delete company restaurant", %{restaurant: restaurant} do
      deleted_restaurant =
        restaurant
        |> Restaurant.delete_restaurant()

      assert deleted_restaurant.hidden == true
    end
  end


  # describe "adding & updating requirements" do
  #   setup [:restaurant_no_requirement_type]

  #   test "Add requirement to restaurant", %{restaurant: restaurant} do
  #     fields = %{
  #       requirements: %{
  #         minimum_time: 24,
  #         minimum_order: 300
  #       }
  #     }

  #     restaurant
  #     |> Restaurant.update_info(fields)
  #     |> assert_requirements(fields)
  #   end

  #   test "Update requirement to restaurant", %{restaurant: restaurant} do
  #     fields_1 = %{
  #       requirements: %{
  #         minimum_time: 24,
  #         minimum_order: 300
  #       }
  #     }

  #     fields_2 = %{
  #       requirements: %{
  #         minimum_time: 50,
  #         minimum_order: 250
  #       }
  #     }

  #     restaurant
  #     |> Restaurant.update_info(fields_1)
  #     |> assert_requirements(fields_1)
  #     |> Restaurant.update_info(fields_2)
  #     |> assert_requirements(fields_2)
  #   end

  #   test "Invalid requirement to restaurant", %{restaurant: restaurant} do
  #     fields_1 = %{
  #       requirements: %{
  #         minimum_time: 24,
  #         minimum_order: 300
  #       }
  #     }

  #     fields_2 = %{
  #       requirements: %{
  #         minimum_time: nil,
  #         minimum_order: "fdsafa"
  #       }
  #     }

  #     fields_3 = %{
  #       requirements: %{
  #         minimum_time: 0,
  #         minimum_order: 0
  #       }
  #     }

  #     restaurant
  #     |> Restaurant.update_info(fields_1)
  #     |> assert_requirements(fields_1)
  #     |> Restaurant.update_info(fields_2)
  #     |> assert_requirements(fields_3)
  #   end
  # end

  # describe "adding & updating delivery fee" do
  #   setup [:restaurant_no_delivery_fee]

  #   test "Add delivery fee to restaurant", %{restaurant: restaurant} do
  #     fields = %{
  #       delivery_fee: %{
  #         fee: 50,
  #         waive_after: 100
  #       }
  #     }

  #     restaurant
  #     |> Restaurant.update_info(fields)
  #     |> assert_delivery_fee(fields)
  #   end

  #   test "Update delivery fee to restaurant", %{restaurant: restaurant} do
  #     fields_1 = %{
  #       delivery_fee: %{
  #         fee: 10,
  #         waive_after: 500
  #       }
  #     }

  #     fields_2 = %{
  #       delivery_fee: %{
  #         fee: 500,
  #         waive_after: 250
  #       }
  #     }

  #     restaurant
  #     |> Restaurant.update_info(fields_1)
  #     |> assert_delivery_fee(fields_1)
  #     |> Restaurant.update_info(fields_2)
  #     |> assert_delivery_fee(fields_2)
  #   end

  #   test "Invalid delivery fee to restaurant", %{restaurant: restaurant} do
  #     fields_1 = %{
  #       delivery_fee: %{
  #         fee: "dfasfa",
  #         waive_after: nil
  #       }
  #     }

  #     fields_2 = %{
  #       delivery_fee: %{
  #         fee: 0,
  #         waive_after: 0
  #       }
  #     }

  #     restaurant
  #     |> Restaurant.update_info(fields_1)
  #     |> assert_delivery_fee(fields_2)
  #   end
  # end

  describe "adding & removing address to restaurant" do
    setup [:restaurant]

    test "Add single address to restaurant", %{restaurant: restaurant} do
      new_address =
        address_fields()
        |> Address.new()

      restaurant_address = restaurant |> Restaurant.add_address(new_address) |> Map.get(:address)

      assert Enum.empty?(restaurant_address) == false
    end

    test "Add multiple address to restaurant", %{restaurant: restaurant} do
      [first_address, second_address] = address_generator(2)

      restaurant_addresses =
        restaurant
        |> Restaurant.add_address(first_address)
        |> Restaurant.add_address(second_address)
        |> Map.get(:address)

      assert length(restaurant_addresses) == 2
    end

    test "Remove existing address from restaurant", %{restaurant: restaurant} do
      new_address = address_fields() |> Address.new()

      restaurant_address = restaurant |> Restaurant.add_address(new_address)

      assert Enum.empty?(restaurant_address.address) == false

      removed_restaurant_address = restaurant_address |> Restaurant.delete_address(new_address)

      assert Enum.empty?(removed_restaurant_address.address) == true
    end

    test "Remove unknown address from restaurant", %{restaurant: restaurant} do
      [first_address] = address_generator(1)

      unknown_address =
        address_fields(%{street: "1213 Chimpunk", postal_code: "M1V2L4"}) |> Address.new()

      restaurant_address =
        restaurant
        |> Restaurant.add_address(first_address)
        |> Restaurant.delete_address(unknown_address)
        |> Map.get(:address)

      assert Enum.empty?(restaurant_address) == false
    end
  end

  describe "add & deleting menu items to restaurant" do
    setup [:restaurant]

    test "adding menu item", %{restaurant: restaurant} do
      menu_item_1 = menu_items_fields() |> MenuItem.new()

      menu_item_2 =
        menu_items_fields(%{name: "Omelette", description: "Egg, butter and cheese."})
        |> MenuItem.new()

      menu_item_3 =
        menu_items_fields(%{name: "Pancake", description: "Breakfast cake."}) |> MenuItem.new()

      menu_item_4 =
        menu_items_fields(%{name: "Steak", category: :lunch, description: "T-bone steak."})
        |> MenuItem.new()

      restaurant
      |> Restaurant.add_menu_item(menu_item_1)
      |> assert_menu(menu_item_1)
      |> Restaurant.add_menu_item(menu_item_2)
      |> assert_menu(menu_item_2)
      |> Restaurant.add_menu_item(menu_item_3)
      |> assert_menu(menu_item_3)
      |> Restaurant.add_menu_item(menu_item_4)
      |> assert_menu(menu_item_4)
    end

    test "deleting menu item", %{restaurant: restaurant} do
      menu_item_1 = menu_items_fields() |> MenuItem.new()

      menu_item_2 =
        menu_items_fields(%{
          name: "Omelette",
          category: :breakfast,
          description: "Egg, butter and cheese."
        })
        |> MenuItem.new()

      menu_item_3 =
        menu_items_fields(%{name: "Steak", category: :lunch, description: "T-bone."})
        |> MenuItem.new()

      restaurant
      |> Restaurant.add_menu_item(menu_item_1)
      |> assert_menu(menu_item_1)
      |> Restaurant.add_menu_item(menu_item_2)
      |> assert_menu(menu_item_2)
      |> Restaurant.delete_menu_item(menu_item_1)
      |> assert_menu_delete(menu_item_1)
      |> Restaurant.add_menu_item(menu_item_3)
      |> assert_menu(menu_item_3)
    end
  end

  defp restaurant(context) do
    restaurant =
      %{
        requirements: restaurant_requirement_fields(),
        delivery_fee: restaurant_delivery_fee_fields()
      }
      |> create_restaurant()
      |> Restaurant.new()

    {:ok, Map.put(context, :restaurant, restaurant)}
  end

  defp restaurant_no_requirement_type(context) do
    restaurant = create_restaurant(:no_requirements) |> Restaurant.new()

    {:ok, Map.put(context, :restaurant, restaurant)}
  end

  defp restaurant_no_delivery_fee(context) do
    restaurant = create_restaurant(:no_delivery_fee) |> Restaurant.new()

    {:ok, Map.put(context, :restaurant, restaurant)}
  end

  defp assert_restaurant(restaurant, fields) do
    IO.inspect(restaurant, label: "RESULTS")
    assert restaurant.name == fields.name
    assert restaurant.cuisine_name == fields.cuisine_name
    assert restaurant.slug == Utility.create_slug(fields.cuisine_name)
    restaurant
  end
  defp assert_requirements(restaurant, fields) do
    assert fields.requirements == restaurant.requirements
    restaurant
  end

  defp assert_delivery_fee(restaurant, fields) do
    assert fields.delivery_fee == restaurant.delivery_fee
    restaurant
  end

  defp assert_menu(restaurant, menu_item) do
    assert get_in(restaurant.menus, [{menu_item.category, menu_item.name}]) == menu_item
    restaurant
  end

  defp assert_menu_delete(restaurant, menu_item) do
    assert get_in(restaurant.menus, [{menu_item.category, menu_item.name}]) == nil
    restaurant
  end

  defp assert_menu_qty(restaurant, qty) do
    menus = restaurant.menus |> Map.keys()
    assert length(menus) == qty
    restaurant
  end
end
