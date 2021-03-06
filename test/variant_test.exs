defmodule VariantTest do
  use ExUnit.Case
  use BigplatesBuilder

  describe "create & update variant" do
    test "create single variant" do
      variant = {variant_fields(), []}

      variant
      |> Variant.new()
      |> assert_variant_fields(variant)
    end

    test "create multiple variant" do
      variant_fields = variant_fields(%{type: :multiple, max_options: 2})

      variant =
        {variant_fields,
         [
           VariantOption.new(variant_option_fields(%{name: "new name 1"})),
           VariantOption.new(variant_option_fields(%{name: "new name 2"}))
         ]}

      variant
      |> Variant.new()
      |> assert_variant_fields(variant)
    end

    test "create single variant with high max options" do
      variant_1 =
        {variant_fields(%{max_options: 2}),
         [
           VariantOption.new(variant_option_fields(%{name: "new name 1"})),
           VariantOption.new(variant_option_fields(%{name: "new name 2"}))
         ]}

      variant_2 =
        {variant_fields(),
         [
           VariantOption.new(variant_option_fields(%{name: "new name 1"})),
           VariantOption.new(variant_option_fields(%{name: "new name 2"}))
         ]}

      variant_1
      |> Variant.new()
      |> assert_variant_fields(variant_2)
    end

    test "update variant field single to multiple" do
      variant_fields_1 = variant_fields()
      variant_fields_2 = variant_fields(%{type: :multiple, max_options: 2})

      variant_1 = {variant_fields_1, []}

      variant_2 =
        {variant_fields_2,
         [
           VariantOption.new(variant_option_fields(%{name: "new name 1"})),
           VariantOption.new(variant_option_fields(%{name: "new name 2"}))
         ]}

      variant_1
      |> Variant.new()
      |> assert_variant_fields(variant_1)
      |> Variant.update(variant_2)
      |> assert_variant_fields(variant_2)
    end

    test "update variant field multiple to multiple" do
      variant_fields_1 = variant_fields(%{type: :multiple, max_options: 2})
      variant_fields_2 = variant_fields(%{type: :multiple, max_options: 3})

      variant_1 =
        {variant_fields_1,
         [
           VariantOption.new(variant_option_fields(%{name: "new name 1"})),
           VariantOption.new(variant_option_fields(%{name: "new name 2"}))
         ]}

      variant_2 =
        {variant_fields_2,
         [
           VariantOption.new(variant_option_fields(%{name: "new name 1"})),
           VariantOption.new(variant_option_fields(%{name: "new name 2"})),
           VariantOption.new(variant_option_fields(%{name: "new name 3"})),
           VariantOption.new(variant_option_fields(%{name: "new name 4"}))
         ]}

      variant_1
      |> Variant.new()
      |> assert_variant_fields(variant_1)
      |> Variant.update(variant_2)
      |> assert_variant_fields(variant_2)
    end

    test "update variant field multiple to single" do
      variant_fields_1 = variant_fields(%{type: :multiple, max_options: 2})
      variant_fields_2 = variant_fields()

      variant_1 =
        {variant_fields_1,
         [
           VariantOption.new(variant_option_fields(%{name: "new name 1"})),
           VariantOption.new(variant_option_fields(%{name: "new name 2"}))
         ]}

      variant_2 =
        {variant_fields_2,
         [
           VariantOption.new(variant_option_fields(%{name: "new name 1"})),
           VariantOption.new(variant_option_fields(%{name: "new name 2"})),
           VariantOption.new(variant_option_fields(%{name: "new name 3"})),
           VariantOption.new(variant_option_fields(%{name: "new name 4"}))
         ]}

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

      variant_1 = {variant_fields_1, [VariantOption.new(%{name: "new name 4"})]}

      variant_2 =
        {variant_fields_2,
         [
           VariantOption.new(variant_option_fields(%{name: "new name 1"})),
           VariantOption.new(variant_option_fields(%{name: "new name 2"}))
         ]}

      valid_variant =
        {valid_field,
         [
           VariantOption.new(variant_option_fields(%{name: "new name 1"})),
           VariantOption.new(variant_option_fields(%{name: "new name 2"}))
         ]}

      variant_1
      |> Variant.new()
      |> assert_variant_fields(variant_1)
      |> Variant.update(variant_2)
      |> assert_variant_fields(valid_variant)
    end
  end

  describe "max options" do
    test "max >= 2 and max <= max_options" do
      variant_fields_1 = variant_fields(%{type: :multiple, max_options: 2})
      variant_fields_2 = variant_fields(%{type: :multiple, max_options: 3})

      variant_1 =
        {variant_fields_1,
         [
           VariantOption.new(variant_option_fields(%{name: "new name 1"})),
           VariantOption.new(variant_option_fields(%{name: "new name 2"}))
         ]}

      variant_2 =
        {variant_fields_2,
         [
           VariantOption.new(variant_option_fields(%{name: "new name 1"})),
           VariantOption.new(variant_option_fields(%{name: "new name 2"})),
           VariantOption.new(variant_option_fields(%{name: "new name 3"})),
           VariantOption.new(variant_option_fields(%{name: "new name 4"}))
         ]}

      variant_1
      |> Variant.new()
      |> assert_variant_fields(variant_1)
      |> assert_max_options(2)

      variant_2
      |> Variant.new()
      |> assert_variant_fields(variant_2)
      |> assert_max_options(3)
    end

    test "max > max_options with empty options" do
      variant_fields_1 = variant_fields(%{type: :multiple, max_options: 5})

      variant_1 =
        {variant_fields_1,
         [
           VariantOption.new(variant_option_fields(%{name: "new name 1"})),
           VariantOption.new(variant_option_fields(%{name: "new name 2"})),
           VariantOption.new(variant_option_fields(%{name: "new name 3"}))
         ]}

      variant_1
      |> Variant.new()
      |> assert_max_options(3)
    end

    test "max > max_options" do
      variant_fields_1 = variant_fields(%{type: :multiple, max_options: 5})

      variant_1 =
        {variant_fields_1,
         [
           VariantOption.new(variant_option_fields(%{name: "new name 1"})),
           VariantOption.new(variant_option_fields(%{name: "new name 2"})),
           VariantOption.new(variant_option_fields(%{name: "new name 3"}))
         ]}

      variant_1
      |> Variant.new()
      |> assert_max_options(3)
    end

    test "max < min_options" do
      variant_fields_1 = variant_fields(%{type: :multiple, max_options: 1})

      variant_1 =
        {variant_fields_1,
         [
           VariantOption.new(variant_option_fields(%{name: "new name 1"})),
           VariantOption.new(variant_option_fields(%{name: "new name 2"})),
           VariantOption.new(variant_option_fields(%{name: "new name 3"}))
         ]}

      variant_1
      |> Variant.new()
      |> assert_max_options(2)
    end
  end

  describe "create & add variant options" do
    test "create single variant" do
      variant_fields = variant_fields()

      options = [
        VariantOption.new(variant_option_fields()),
        VariantOption.new(variant_option_fields(%{name: "new name"}))
      ]

      variant = {variant_fields, options}

      new_options = [
        VariantOption.new(variant_option_fields(%{name: "added new one", price: 50}))
      ]

      updated_variant = {variant_fields, new_options ++ options}

      variant
      |> Variant.new()
      |> assert_variant_fields(variant)
      |> Variant.add_variant_option(new_options)
      |> assert_variant_fields(updated_variant)
    end

    test "create multiple variant" do
      variant_fields = variant_fields(%{type: :multiple, max_options: 2})

      options = [
        VariantOption.new(variant_option_fields()),
        VariantOption.new(variant_option_fields(%{name: "new name"})),
        VariantOption.new(
          variant_option_fields(%{
            name: "Medium rare",
            price: 0,
            description: "Medium rare on the grill."
          })
        )
      ]

      variant = {variant_fields, options}

      new_option = [
        VariantOption.new(variant_option_fields(%{name: "new_1", price: 50})),
        VariantOption.new(variant_option_fields(%{name: "new_2", price: 10})),
        VariantOption.new(variant_option_fields(%{name: "new_3", price: 0}))
      ]

      updated_variant = {variant_fields, new_option ++ options}

      variant
      |> Variant.new()
      |> assert_variant_fields(variant)
      |> Variant.add_variant_option(new_option)
      |> assert_variant_fields(updated_variant)
    end
  end

  describe "update variant options" do
    test "create single variant" do
      variant_fields = variant_fields()

      options = [
        VariantOption.new(variant_option_fields()),
        VariantOption.new(variant_option_fields(%{name: "new name"}))
      ]

      variant = {variant_fields, options}

      new_option = [VariantOption.new(variant_option_fields(%{name: "added new one", price: 50}))]
      updated_variant = {variant_fields, new_option ++ options}

      variant
      |> Variant.new()
      |> assert_variant_fields(variant)
      |> Variant.add_variant_option(new_option)
      |> assert_variant_fields(updated_variant)
    end

    test "create multiple variant" do
      variant_fields = variant_fields(%{type: :multiple, max_options: 2})

      options = [
        VariantOption.new(variant_option_fields()),
        VariantOption.new(variant_option_fields(%{name: "new name"})),
        VariantOption.new(
          variant_option_fields(%{
            name: "Medium rare",
            price: 0,
            description: "Medium rare on the grill."
          })
        )
      ]

      variant = {variant_fields, options}

      new_option = [
        VariantOption.new(variant_option_fields(%{name: "new_1", price: 50})),
        VariantOption.new(variant_option_fields(%{name: "new_2", price: 10})),
        VariantOption.new(variant_option_fields(%{name: "new_3", price: 0}))
      ]

      updated_variant = {variant_fields, new_option ++ options}

      variant
      |> Variant.new()
      |> assert_variant_fields(variant)
      |> Variant.add_variant_option(new_option)
      |> assert_variant_fields(updated_variant)
    end
  end

  defp assert_variant_fields(variant, {variant_fields, variant_option_fields}) do
    assert variant_fields.name == variant.name
    assert variant_fields.type == variant.type
    assert variant_fields.max_options == variant.max_options
    assert variant_fields.required == variant.required
    assert Enum.empty?(variant.options) == Enum.empty?(variant_option_fields)
    variant
  end

  defp assert_max_options(variant, valid_max_options) do
    assert variant.max_options == valid_max_options
    variant
  end
end
