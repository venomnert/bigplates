defmodule Bigplates.Core.Variant do
  @variant_types [:single, :multiple]

  alias Bigplates.Core.VariantOption

  defstruct name: nil,
            type: nil,
            max_options: 1,
            required: false,
            options: %{}

  def new({variant_fields, variant_options}) do
    struct!(__MODULE__, variant_fields)
    |> add_variant_option(variant_options)
    |> enforce_limits()
  end

  def enforce_limits(variant) do
    variant
    |> enforce_single_limit()
    |> enforce_multiple_limit()
  end

  def add_variant_option(variant, variant_options) do
    variant
    |> add_multiple_variant_options(variant_options)
    |> enforce_limits()
  end

  def remove_variant_option(variant, variant_option) do
    updated_options =
      variant.options
      |> Map.delete(variant_option.name)

    variant |> Map.put(:options, updated_options)
  end

  defp find_variant_option_index(variant_options, %{name: name} = variant_option) do
    variant_options
    |> Enum.find_index(&(&1.name == name))
  end

  def update(
        variant,
        {%{name: name, type: type, required: required} = variant_fields, variant_options}
      ) do
    %{variant | name: name, type: type, required: required}
    |> update_variant_options({variant_fields, variant_options})
  end

  def update(variant, variant_fields) do
    variant
    |> Map.merge(variant_fields)
    |> enforce_limits()
  end

  def update_variant_options(
        variant,
        {%{max_options: max_options} = variant_fields, variant_options}
      ) do
    %{variant | max_options: max_options, options: %{}}
    |> add_variant_option(variant_options)
    |> enforce_limits()
  end

  defp enforce_single_limit(%{type: :multiple} = variant), do: variant

  defp enforce_single_limit(%{type: :single} = variant) do
    variant
    |> Map.put(:max_options, 1)
  end

  defp enforce_multiple_limit(%{type: :single, max_options: _max} = variant),
    do: variant

  defp enforce_multiple_limit(%{type: :multiple, max_options: max, options: options} = variant) do
    max_options = options |> Map.keys() |> length()
    min_options = 2

    cond do
      max >= min_options and max <= max_options -> variant
      max > max_options -> variant |> Map.put(:max_options, max_options)
      max < min_options -> variant |> Map.put(:max_options, min_options)
      true -> variant
    end
  end

  defp add_multiple_variant_options(variant, variant_option_fields)
       when is_list(variant_option_fields) do
    variant_option_fields
    |> Enum.reduce(variant, &add_variant_options(&2, &1))
  end

  defp add_variant_options(variant, variant_option_fields) do
    variant_option = VariantOption.new(variant_option_fields)

    updated_options =
      variant.options
      |> Map.put(variant_option.name, variant_option)

    variant |> Map.put(:options, updated_options)
  end
end
