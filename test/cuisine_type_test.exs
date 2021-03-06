defmodule CuisineTypeTest do
  use ExUnit.Case
  use BigplatesBuilder

  describe "adding & removing cuisine type to restaurant" do
    setup [:restaurant]

    # Since this throws an error, should this be handled by Boundry layer?
    test "Invalid cuisine type to restaurant", %{restaurant: _restaurant} do
      cuisine_fields(%{english: true, french: false})
      |> assert_cuisine_types_error()
    end
  end

  defp restaurant(context) do
    restaurant = create_restaurant(%{}) |> Restaurant.new()
    {:ok, Map.put(context, :restaurant, restaurant)}
  end

  defp assert_cuisine_types_error(fields) do
    assert_raise KeyError, fn -> CuisineType.new(fields) end
  end
end
