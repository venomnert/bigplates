defmodule PortionSizeTest do
  use ExUnit.Case
  use BigplatesBuilder

  describe "create & update portion size" do
    test "create portion size" do
      field_1 = portion_size_fields()

      field_1
      |> PortionSize.new()
      |> assert_portion_size(field_1)
    end

    test "update portion size" do
      field_1 = portion_size_fields()
      field_2 = portion_size_fields(%{type: :per_person, increment: 2, sale_price: 10})
      field_3 = portion_size_fields(%{type: :tray, portion: :medium, price: 10, min: 5, max: 10})

      field_1
      |> PortionSize.new()
      |> assert_portion_size(field_1)
      |> PortionSize.update(field_2)
      |> assert_portion_size(field_2)
      |> PortionSize.update(field_3)
      |> assert_portion_size(field_3)
    end

    test "validate description" do
      portion_size_field_1 = portion_size_fields()
      portion_size_field_2 = portion_size_fields(%{portion: :medium, sale_price: 10})

      portion_size_field_1
      |> PortionSize.new()
      |> assert_portion_size(portion_size_field_1)
      |> assert_description()
      |> PortionSize.update(portion_size_field_2)
      |> assert_portion_size(portion_size_field_2)
      |> assert_description()
    end
  end

  defp assert_portion_size(%{type: :tray} = portion_size, fields) do
    assert portion_size.price == fields.price
    assert portion_size.sale_price == fields.sale_price
    assert portion_size.min > 0
    assert portion_size.max > 0

    portion_size
  end

  defp assert_portion_size(%{type: :per_person} = portion_size, fields) do
    assert portion_size.price == fields.price
    assert portion_size.sale_price == fields.sale_price
    assert portion_size.increment == fields.increment

    portion_size
  end

  defp assert_description(%{type: :tray} = portion_size) do
    assert portion_size.description == get_description(portion_size, "people")
    portion_size
  end

  defp get_description(%{type: :tray} = portion_size, entity) do
    "#{portion_size.portion}: #{portion_size.min} - #{portion_size.max} #{entity}"
  end
end
