defmodule RestaurantTest do
  use ExUnit.Case
  use BigplatesBuilder

  @default_order_requirement %{minimum_time: 0, minimum_order: 0}
  @default_delivery_requirement %{fee: 0, waive_after: 0}


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


  describe "adding & updating requirements" do
    setup [:restaurant]

    test "Add requirement to restaurant", %{restaurant: restaurant} do
      fields = %{
        minimum_time: 24,
        minimum_order: 300
      }

      restaurant
      |> Restaurant.update_order_requirement(fields)
      |> assert_order_requirements(fields)
    end

    test "Update requirement to restaurant", %{restaurant: restaurant} do
      fields_1 = %{
        minimum_time: 24,
        minimum_order: 300
      }

      fields_2 = %{
        minimum_time: 12,
        minimum_order: 100
      }

      restaurant
      |> Restaurant.update_order_requirement(fields_1)
      |> assert_order_requirements(fields_1)
      |> Restaurant.update_order_requirement(fields_2)
      |> assert_order_requirements(fields_2)
    end

    test "Invalid requirement to restaurant", %{restaurant: restaurant} do
      fields_1 = %{
        minimum_time: 24,
        minimum_order: 300
      }

      fields_2 = %{
        minimum_time: nil,
        minimum_order: "fdsafa"
      }

      restaurant
      |> Restaurant.update_order_requirement(fields_1)
      |> assert_order_requirements(fields_1)
      |> Restaurant.update_order_requirement(fields_2)
      |> assert_order_requirements(@default_order_requirement)
    end
  end

  describe "adding & updating delivery fee" do
    setup [:restaurant]

    test "Add delivery fee to restaurant", %{restaurant: restaurant} do
      fields = %{
        fee: 50,
        waive_after: 100
      }

      restaurant
      |> Restaurant.update_delivery_requirement(fields)
      |> assert_delivery_requirement(fields)
    end

    test "Update delivery fee to restaurant", %{restaurant: restaurant} do
      fields_1 = %{
        fee: 10,
        waive_after: 500
      }

      fields_2 = %{
        fee: 500,
        waive_after: 250
      }

      restaurant
      |> Restaurant.update_delivery_requirement(fields_1)
      |> assert_delivery_requirement(fields_1)
      |> Restaurant.update_delivery_requirement(fields_2)
      |> assert_delivery_requirement(fields_2)
    end

    test "Invalid delivery fee to restaurant", %{restaurant: restaurant} do
      fields_1 = %{
        fee: "dfasfa",
        waive_after: nil
      }

      restaurant
      |> Restaurant.update_delivery_requirement(fields_1)
      |> assert_delivery_requirement(@default_delivery_requirement)
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
    restaurant = create_restaurant(%{}) |> Restaurant.new()

    {:ok, Map.put(context, :restaurant, restaurant)}
  end

  defp assert_restaurant(restaurant, fields) do
    assert restaurant.name == fields.name
    assert restaurant.cuisine_name == fields.cuisine_name
    assert restaurant.slug == Utility.create_slug(fields.cuisine_name)
    restaurant
  end
  defp assert_order_requirements(restaurant, fields) do
    order_requirement = Map.from_struct(restaurant.order_requirement)
    assert Map.equal?(order_requirement, fields) == true
    restaurant
  end

  defp assert_delivery_requirement(restaurant, fields) do
    delivery_requirement = Map.from_struct(restaurant.delivery_requirement)
    assert Map.equal?(delivery_requirement, fields) == true
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
