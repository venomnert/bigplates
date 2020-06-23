defmodule PortionSizeTest do
  use ExUnit.Case
  use BigplatesBuilder

  describe "create & update portion size" do
    test "create portion size" do
      portion_size_field = portion_size_fields()

      portion_size_field
      |> PortionSize.new()
      |> assert_portion_size(portion_size_field)
    end

    test "update portion size" do
      portion_size_field_1 = portion_size_fields()
      portion_size_field_2 = portion_size_fields(%{name: :medium, sale_price: 10})

      portion_size_field_1
      |> PortionSize.new()
      |> assert_portion_size(portion_size_field_1)
      |> PortionSize.update(portion_size_field_2)
      |> assert_portion_size(portion_size_field_2)
    end

    # Test in boundry layer
    test "invalide size name" do
    end

    test "validate description" do
      portion_size_field_1 = portion_size_fields()
      portion_size_field_2 = portion_size_fields(%{name: :medium, sale_price: 10})

      portion_size_field_1
      |> PortionSize.new()
      |> assert_portion_size(portion_size_field_1)
      |> assert_description()
      |> PortionSize.update(portion_size_field_2)
      |> assert_portion_size(portion_size_field_2)
      |> assert_description()
    end
  end

  defp assert_portion_size(portion_size, fields) do
    %{min: min, max: max} = portion_size.name |> PortionSize.get_range()

    assert fields.name == portion_size.name
    assert fields.price == portion_size.price
    assert fields.sale_price == portion_size.sale_price
    assert min == portion_size.min
    assert max == portion_size.max

    portion_size
  end

  defp assert_description(portion_size) do
    assert portion_size.description == get_description(portion_size, "people")
    portion_size
  end

  defp get_description(portion_size, entity) do
    "#{portion_size.name}: #{portion_size.min} - #{portion_size.max} #{entity}"
  end
end
