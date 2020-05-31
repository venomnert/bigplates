defmodule RestaurantTest do
  use ExUnit.Case
  use BigplatesBuilder

  describe "adding & updating cuisine type to restaurant" do
    setup [:restaurant_no_cuisine_type]

    test "Add cuisine type to restaurant", %{restaurant: restaurant} do
      new_cuisine = cuisinine_fields() |> CuisineType.new()

      restaurant_cuisine_types =
        restaurant
        |> Restaurant.add_cuisine(new_cuisine)
        |> Map.get(:cuisine_types)

      assert restaurant_cuisine_types == new_cuisine
    end

    test "Update cuisine type to restaurant", %{restaurant: restaurant} do
      new_cuisine_1 = cuisinine_fields() |> CuisineType.new()

      new_cuisine_2 =
        cuisinine_fields(%{
          sri_lankan: true,
          indian: true,
          caribbean: true,
          thai: true,
          filipino: false
        })

      updated_cuisine_types = new_cuisine_1 |> struct(new_cuisine_2)

      restaurant
      |> Restaurant.add_cuisine(new_cuisine_1)
      |> assert_cuisine_type(new_cuisine_1)
      |> Restaurant.update_cuisine(new_cuisine_2)
      |> assert_cuisine_type(updated_cuisine_types)
    end

    # Since this throws an error, should this be handled by Boundry layer?
    # test "Invalid update cuisine type call", %{restaurant: restaurant} do
    #   new_cuisine_1 = cuisinine_fields() |> CuisineType.new()

    #   new_cuisine_2 =
    #     cuisinine_fields(%{
    #       sri_lankan: true,
    #       english: true
    #     })

    #   restaurant
    #   |> Restaurant.add_cuisine(new_cuisine_1)
    #   |> assert_cuisine_type(new_cuisine_1)
    #   |> Restaurant.update_cuisine(new_cuisine_2)
    #   |> assert_cuisine_types_error()
    # end
  end

  describe "adding & updating requirements" do
    setup [:restaurant_no_requirement_type]

    test "Add requirement to restaurant", %{restaurant: restaurant} do
      fields = %{
        requirements: %{
          minimum_time: 24,
          minimum_order: 300
        }
      }

      restaurant
      |> Restaurant.update_info(fields)
      |> assert_requirements(fields)
    end

    test "Update requirement to restaurant", %{restaurant: restaurant} do
      fields_1 = %{
        requirements: %{
          minimum_time: 24,
          minimum_order: 300
        }
      }

      fields_2 = %{
        requirements: %{
          minimum_time: 50,
          minimum_order: 250
        }
      }

      restaurant
      |> Restaurant.update_info(fields_1)
      |> assert_requirements(fields_1)
      |> Restaurant.update_info(fields_2)
      |> assert_requirements(fields_2)
    end

    test "Invalid requirement to restaurant", %{restaurant: restaurant} do
      fields_1 = %{
        requirements: %{
          minimum_time: 24,
          minimum_order: 300
        }
      }

      fields_2 = %{
        requirements: %{
          minimum_time: nil,
          minimum_order: "fdsafa"
        }
      }

      fields_3 = %{
        requirements: %{
          minimum_time: 0,
          minimum_order: 0
        }
      }

      restaurant
      |> Restaurant.update_info(fields_1)
      |> assert_requirements(fields_1)
      |> Restaurant.update_info(fields_2)
      |> assert_requirements(fields_3)
    end
  end

  describe "adding & updating delivery fee" do
    setup [:restaurant_no_delivery_fee]

    test "Add delivery fee to restaurant", %{restaurant: restaurant} do
      fields = %{
        delivery_fee: %{
          fee: 50,
          waive_after: 100
        }
      }

      restaurant
      |> Restaurant.update_info(fields)
      |> assert_delivery_fee(fields)
    end

    test "Update delivery fee to restaurant", %{restaurant: restaurant} do
      fields_1 = %{
        delivery_fee: %{
          fee: 10,
          waive_after: 500
        }
      }

      fields_2 = %{
        delivery_fee: %{
          fee: 500,
          waive_after: 250
        }
      }

      restaurant
      |> Restaurant.update_info(fields_1)
      |> assert_delivery_fee(fields_1)
      |> Restaurant.update_info(fields_2)
      |> assert_delivery_fee(fields_2)
    end

    test "Invalid delivery fee to restaurant", %{restaurant: restaurant} do
      fields_1 = %{
        delivery_fee: %{
          fee: "dfasfa",
          waive_after: nil
        }
      }

      fields_2 = %{
        delivery_fee: %{
          fee: 0,
          waive_after: 0
        }
      }

      restaurant
      |> Restaurant.update_info(fields_1)
      |> assert_delivery_fee(fields_2)
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

      removed_restaurant_address = restaurant_address |> Restaurant.remove_address(new_address)

      assert Enum.empty?(removed_restaurant_address.address) == true
    end

    test "Remove unknown address from restaurant", %{restaurant: restaurant} do
      [first_address] = address_generator(1)

      unknown_address =
        address_fields(%{street: "1213 Chimpunk", postal_code: "M1V2L4"}) |> Address.new()

      restaurant_address =
        restaurant
        |> Restaurant.add_address(first_address)
        |> Restaurant.remove_address(unknown_address)
        |> Map.get(:address)

      assert Enum.empty?(restaurant_address) == false
    end
  end

  describe "deleting restaurant" do
    setup [:restaurant]

    test "delete company restaurant", %{restaurant: restaurant} do
      deleted_restaurant =
        restaurant
        |> Restaurant.delete_restaurant()

      assert deleted_restaurant.hidden == true
    end
  end

  describe "add & deleting menus to restaurant" do
    setup [:restaurant]

    test "adding menu", %{restaurant: restaurant} do
      menu_1 = %{name: "Breakfast", meal_category: :breakfast} |> Menu.new()
      menu_2 = %{name: "Scoops", meal_category: nil} |> Menu.new()
      menu_3 = %{name: "Dough Pops", meal_category: :lunch} |> Menu.new()
      menu_4 = %{name: "Dough Truffles", meal_category: nil} |> Menu.new()

      restaurant
      |> Restaurant.add_menu(menu_1)
      |> assert_menu(menu_1)
      |> Restaurant.add_menu(menu_2)
      |> Restaurant.add_menu(menu_3)
      |> Restaurant.add_menu(menu_4)
    end

    test "deleting menu", %{restaurant: restaurant} do
      menu_1 = %{name: "Breakfast", meal_category: :breakfast} |> Menu.new()
      menu_2 = %{name: "Scoops", meal_category: nil} |> Menu.new()

      restaurant
      |> Restaurant.add_menu(menu_1)
      |> assert_menu(menu_1)
      |> Restaurant.add_menu(menu_2)
      |> Restaurant.delete_menu(menu_1)
      |> assert_menu_delete(menu_1)
      |> assert_menu_qty(1)
    end
  end

  defp restaurant(context) do
    restaurant =
      %{
        requirements: restaurant_requirement_fields(),
        delivery_fee: restaurant_delivery_fee_fields(),
        cuisine_types: CuisineType.new(cuisinine_fields())
      }
      |> create_restaurant()
      |> Restaurant.new()

    {:ok, Map.put(context, :restaurant, restaurant)}
  end

  defp restaurant_no_cuisine_type(context) do
    restaurant = create_restaurant(:no_cuisine_type) |> Restaurant.new()

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

  defp assert_cuisine_type(restaurant, cuisine_types) do
    assert restaurant.cuisine_types == cuisine_types
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

  defp assert_menu(restaurant, fields) do
    slug = Utility.create_slug(fields.name)
    menu = restaurant.menus |> Map.get(slug)
    assert fields.name == menu.name
    assert fields.meal_category == menu.meal_category
    assert fields.slug == menu.slug
    restaurant
  end

  defp assert_menu_delete(restaurant, menu) do
    result =
      restaurant.menus
      |> Enum.member?(menu.slug)

    assert result == false

    restaurant
  end

  defp assert_menu_qty(restaurant, qty) do
    menus = restaurant.menus |> Map.keys
    assert length(menus) == qty
    restaurant
  end
end
