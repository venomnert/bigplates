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
    setup [:restaurant_no_requirement_type]

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

  defp restaurant_no_cuisine_type(context) do
    restaurant =
      create_restaurant(%{
        requirements: %{
          minimum_time: 24,
          minimum_order: 300,
          delivery_fee: %{
            fee: 20,
            waive_after: 1000
          }
        }
      })
      |> Restaurant.new()

    {:ok, Map.put(context, :restaurant, restaurant)}
  end

  defp restaurant_no_requirement_type(context) do
    new_cuisine = cuisinine_fields() |> CuisineType.new()

    restaurant =
      create_restaurant()
      |> Restaurant.new()
      |> Restaurant.add_cuisine(new_cuisine)

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
end
