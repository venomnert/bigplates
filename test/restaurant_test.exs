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

  describe "CRUD menu items to restaurant" do
    setup [:restaurant]

    test "adding menu item", %{restaurant: restaurant} do
      menu_item_1 = menu_items_fields() |> MenuItem.new()

      menu_item_2 =
        menu_items_fields(%{name: "Omelette", description: "Egg, butter and cheese."})
        |> MenuItem.new()

      menu_item_3 =
        menu_items_fields(%{name: "Pancake", description: "Breakfast cake."}) |> MenuItem.new()

      menu_item_4 =
        menu_items_fields(%{name: "Steak", categories: [:lunch, :dinner], description: "T-bone steak."})
        |> MenuItem.new()

      menu_item_5 =
        menu_items_fields(%{name: "Steak", categories: [:breakfast, :lunch, :dinner], description: "T-bone steak."})
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
      |> Restaurant.add_menu_item(menu_item_5)
      |> assert_menu(menu_item_5)
    end

    test "deleting menu item", %{restaurant: restaurant} do
      menu_item_1 = menu_items_fields() |> MenuItem.new()

      menu_item_2 =
        menu_items_fields(%{
          name: "Omelette",
          categories: [:breakfast, :lunch],
          description: "Egg, butter and cheese."
        })
        |> MenuItem.new()

      menu_item_3 =
        menu_items_fields(%{name: "Steak", categories: [:lunch], description: "T-bone."})
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

    test "update menu item", %{restaurant: restaurant} do
      menu_item_1 =
        menu_items_fields(%{name: "Steak", categories: [:lunch, :dinner], description: "T-bone steak."})
        |> MenuItem.new()

      menu_item_2 =
        menu_item_1
        |> MenuItem.update_menu_item(%{name: "AAA Steak", categories: [:breakfast, :lunch, :dinner], description: "T-bone steak."})

      restaurant
      |> Restaurant.add_menu_item(menu_item_1)
      |> assert_menu(menu_item_1)
      |> Restaurant.update_menu_item(menu_item_1, menu_item_2)
      |> assert_menu(menu_item_2)
    end
  end

  defp restaurant(context) do
    restaurant = create_restaurant(%{}) |> Restaurant.new()

    {:ok, Map.put(context, :restaurant, restaurant)}
  end

  defp assert_restaurant(restaurant, fields) do
    assert restaurant.name == fields.name
    assert restaurant.cuisine_name == fields.cuisine_name
    assert restaurant.slug == Utility.create_slug(fields.cuisine_name)
    restaurant
  end

  defp assert_menu(restaurant, menu_item) do
    assert Enum.member?(restaurant.menus, menu_item) == true
    restaurant
  end

  defp assert_menu_delete(restaurant, menu_item) do
    assert Enum.member?(restaurant.menus, menu_item) == false
    restaurant
  end
end
