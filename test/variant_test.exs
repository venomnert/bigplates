defmodule VariantTest do
  use ExUnit.Case
  use BigplatesBuilder

  describe "create & update variant" do
    test "create single variant" do
      variant_fields = variant_fields()
      variant = {variant_fields, []}

      variant
      |> Variant.new()
      |> assert_variant_fields(variant)
    end

    test "create multiple variant" do
      variant_fields = variant_fields(%{type: :multiple, max_options: 2})
      variant = {variant_fields, [%{}, %{}]}

      variant
      |> Variant.new()
      |> assert_variant_fields(variant)
    end

    test "create single variant with high max options" do
      variant_1 = {variant_fields(%{max_options: 2}), [%{}, %{}]}
      variant_2 = {variant_fields(), [%{}, %{}]}

      variant_1
      |> Variant.new()
      |> assert_variant_fields(variant_2)
    end

    test "update variant field single to multiple" do
      variant_fields_1 = variant_fields()
      variant_fields_2 = variant_fields(%{type: :multiple, max_options: 2})

      variant_1 = {variant_fields_1, []}
      variant_2 = {variant_fields_2, [%{}, %{}]}

      variant_1
      |> Variant.new()
      |> assert_variant_fields(variant_1)
      |> Variant.update(variant_2)
      |> assert_variant_fields(variant_2)
    end

    test "update variant field multiple to multiple" do
      variant_fields_1 = variant_fields(%{type: :multiple, max_options: 2})
      variant_fields_2 = variant_fields(%{type: :multiple, max_options: 3})

      variant_1 = {variant_fields_1, [%{}, %{}]}
      variant_2 = {variant_fields_2, [%{}, %{}, %{}, %{}]}

      variant_1
      |> Variant.new()
      |> assert_variant_fields(variant_1)
      |> Variant.update(variant_2)
      |> assert_variant_fields(variant_2)
    end

    test "update variant field multiple to single" do
      variant_fields_1 = variant_fields(%{type: :multiple, max_options: 2})
      variant_fields_2 = variant_fields()

      variant_1 = {variant_fields_1, [%{}, %{}, %{}]}
      variant_2 = {variant_fields_2, [%{}, %{}]}

      variant_1
      |> Variant.new()
      |> assert_variant_fields(variant_1)
      |> Variant.update(variant_2)
      |> assert_variant_fields(variant_2)
    end

    test "update variant field single to single" do
      variant_fields_1 = variant_fields()
      variant_fields_2 = variant_fields(%{name: "Burger", max_options: 2, required: false})
      valid_field = variant_fields_2 |> Map.put(:max_options, 1)

      variant_1 = {variant_fields_1, [%{}]}
      variant_2 = {variant_fields_2, [%{}, %{}]}
      valid_variant = {valid_field, [%{}, %{}]}

      variant_1
      |> Variant.new()
      |> assert_variant_fields(variant_1)
      |> Variant.update(variant_2)
      |> assert_variant_fields(valid_variant)
    end
  end

  describe "testing max options" do
    test "max >= 2 and max <= max_options " do
      variant_fields_1 = variant_fields(%{type: :multiple, max_options: 2})
      variant_fields_2 = variant_fields(%{type: :multiple, max_options: 3})

      variant_1 = {variant_fields_1, [%{},%{}]}
      variant_2 = {variant_fields_2, [%{},%{},%{},%{}]}

      variant_1
      |> Variant.new()
      |> assert_variant_fields(variant_1)
      |> assert_max_options(2)

      variant_2
      |> Variant.new()
      |> assert_variant_fields(variant_2)
      |> assert_max_options(3)
    end

    # max > min_options and max <= max_options -> variant
    # max > max_options -> variant |> Map.put(:max_options, max_options)
    # max < min_options -> variant |> Map.put(:max_options, min_options)

  end

  # describe "create & update variant options" do
  #   test "create variant field" do
  #     variant_fields = variant_fields()
  #     variant = {variant_fields, []}

  #     variant
  #     |> Variant.new()
  #     |> assert_variant_fields(variant)
  #   end

  #   test "update variant field single to multiple" do
  #     variant_fields_1 = variant_fields()
  #     variant_fields_2 = variant_fields(%{type: :multiple, max_options: 2})

  #     variant_1 = {variant_fields_1, []}
  #     variant_2 = {variant_fields_2, [%{}, %{}]}

  #     variant_1
  #     |> Variant.new()
  #     |> assert_variant_fields(variant_1)
  #     |> Variant.update(variant_2)
  #     |> assert_variant_fields(variant_2)
  #   end

  #   test "update variant field multiple to multiple" do
  #     variant_fields_1 = variant_fields()
  #     variant_fields_2 = variant_fields(%{type: :multiple, max_options: 2})

  #     variant_1 = {variant_fields_1, []}
  #     variant_2 = {variant_fields_2, [%{}, %{}]}

  #     variant_1
  #     |> Variant.new()
  #     |> assert_variant_fields(variant_1)
  #     |> Variant.update(variant_2)
  #     |> assert_variant_fields(variant_2)
  #   end

  #   test "update variant field multiple to single" do
  #     variant_fields_1 = variant_fields()
  #     variant_fields_2 = variant_fields(%{type: :multiple, max_options: 2})

  #     variant_1 = {variant_fields_1, []}
  #     variant_2 = {variant_fields_2, [%{}, %{}]}

  #     variant_1
  #     |> Variant.new()
  #     |> assert_variant_fields(variant_1)
  #     |> Variant.update(variant_2)
  #     |> assert_variant_fields(variant_2)
  #   end

  #   test "update variant field single to single" do
  #     variant_fields_1 = variant_fields()
  #     variant_fields_2 = variant_fields(%{type: :multiple, max_options: 2})

  #     variant_1 = {variant_fields_1, []}
  #     variant_2 = {variant_fields_2, [%{}, %{}]}

  #     variant_1
  #     |> Variant.new()
  #     |> assert_variant_fields(variant_1)
  #     |> Variant.update(variant_2)
  #     |> assert_variant_fields(variant_2)
  #   end
  # end

  # describe "create & update variant to menu" do
  #   test "create variant" do
  #     variant_fields = variant_fields()
  #     variant_option_fields = variant_option_fields()
  #     variant = {variant_fields, variant_option_fields} |> Variant.new()

  #     menu_field
  #     |> Menu.new()
  #     |> assert_menu(menu_field)
  #   end

  #   test "update variant" do
  #     menu_field_1 = menu_fields()
  #     menu_field_2 = menu_fields(%{name: "Lunch Special", meal_category: :lunch})

  #     menu_field_1
  #     |> Menu.new()
  #     |> assert_menu(menu_field_1)
  #     |> Menu.update_menu(menu_field_2)
  #     |> assert_menu(menu_field_2)
  #   end
  # end

  defp assert_variant_fields(variant, {variant_fields, variant_option_fields}) do
    assert variant_fields.name == variant.name
    assert variant_fields.type == variant.type
    assert variant_fields.max_options == variant.max_options
    assert variant_fields.required == variant.required
    assert length(variant.options) == length(variant_option_fields)
    variant
  end

  defp assert_max_options(variant, valid_max_options) do
    assert variant.max_options == valid_max_options
    variant
  end
end
