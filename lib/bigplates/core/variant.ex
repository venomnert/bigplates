defmodule Bigplates.Core.Variant do
  @variant_types [:single, :multiple]

  alias Bigplates.Core.VariantItem

  defstruct name: nil,
            type: nil,
            max_options: 1,
            required: false,
            options: []

  def new({variant_fields, variant_items}) do
    struct!(__MODULE__, variant_fields)
    |> add_options(variant_items)
    |> enforce_limits()
  end

  def enforce_limits(variant) do
    variant
    |> enforce_single_limit()
    |> enforce_multiple_limit()
  end


  def add_options(%__MODULE__{} = variant, variant_items) do
    variant
    |> add_multiple_variant_items(variant_items)
  end

  def update(variant, {%{name: name, type: type, required: required} = variant_fields, variant_items}) do
    %{variant | name: name, type: type, required: required}
    |> update_variant_items({variant_fields, variant_items})
  end

  def update_variant_items(variant, {%{max_options: max_options} = variant_fields, variant_items}) do
    %{variant | max_options: max_options, options: []}
    |> add_options(variant_items)
    |> enforce_limits()
  end

  defp enforce_single_limit(%__MODULE__{type: :multiple} = variant), do: variant

  defp enforce_single_limit(%__MODULE__{type: :single} = variant) do
    variant
    |> Map.put(:max_options, 1)
  end

  defp enforce_multiple_limit(%__MODULE__{type: :single, max_options: _max} = variant), do: variant

  defp enforce_multiple_limit(%__MODULE__{type: :multiple, max_options: max, options: options} = variant) do
    max_options = length(options)
    min_options = 2

    cond do
      max >= 2 and max <= max_options -> variant
      max > min_options and max <= max_options -> variant
      max > max_options -> variant |> Map.put(:max_options, max_options)
      max < min_options -> variant |> Map.put(:max_options, min_options)
      true -> variant |> Map.put(:max_options, min_options)
    end

  end

  defp add_multiple_variant_items(variant, fields) when is_list(fields) do
    fields
    |> Enum.reduce(variant, &add_variant_item(&2, &1))
  end

  defp add_variant_item(variant, fields) do
    updated_options = [VariantItem.new(fields)] ++ variant.options

    variant |> Map.put(:options, updated_options)
  end
end
