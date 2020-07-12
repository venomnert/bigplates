defmodule VariantItemTest do
  use ExUnit.Case
  use BigplatesBuilder

  describe "create & update variant items" do
    test "create variant item" do
      variant_item = variant_item_fields()

      variant_item
      |> VariantItem.new()
      |> assert_variant_item(variant_item)
    end

    test "update variant item" do
      variant_item_1 = variant_item_fields()

      variant_item_2 =
        variant_item_fields(%{price: 0, description: "Changed."})

      variant_test = variant_item_fields() |> Map.merge(variant_item_2)

      variant_item_3 =
        variant_item_fields(%{name: "Medium Rare", price: 0, description: "Steak cooked medium rare on the grill."})

      variant_item_1
      |> VariantItem.new()
      |> assert_variant_item(variant_item_1)
      |> VariantItem.update(variant_item_2)
      |> assert_variant_item(variant_test)
      |> VariantItem.update(variant_item_3)
      |> assert_variant_item(variant_item_3)
    end
  end

  defp assert_variant_item(variant_item, variant_item_fields) do
    assert variant_item_fields.name == variant_item.name
    assert variant_item_fields.price == variant_item.price
    assert variant_item_fields.description == variant_item.description
    variant_item
  end
end
