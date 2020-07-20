defmodule VariantOptionTest do
  use ExUnit.Case
  use BigplatesBuilder

  describe "create & update variant options" do
    test "create variant option" do
      variant_option = variant_option_fields()

      variant_option
      |> VariantOption.new()
      |> assert_variant_option(variant_option)
    end

    test "update variant option" do
      variant_option_1 = variant_option_fields()

      variant_option_2 = variant_option_fields(%{price: 0, description: "Changed."})

      variant_test = variant_option_fields() |> Map.merge(variant_option_2)

      variant_option_3 =
        variant_option_fields(%{
          name: "Medium Rare",
          price: 0,
          description: "Steak cooked medium rare on the grill."
        })

      variant_option_1
      |> VariantOption.new()
      |> assert_variant_option(variant_option_1)
      |> VariantOption.update(variant_option_2)
      |> assert_variant_option(variant_test)
      |> VariantOption.update(variant_option_3)
      |> assert_variant_option(variant_option_3)
    end
  end

  defp assert_variant_option(variant_option, variant_option_fields) do
    assert variant_option_fields.name == variant_option.name
    assert variant_option_fields.price == variant_option.price
    assert variant_option_fields.description == variant_option.description
    variant_option
  end
end
