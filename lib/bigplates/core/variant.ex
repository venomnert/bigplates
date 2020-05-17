defmodule Bigplates.Core.Variant do
  @variant_types [:single, :multiple]

  alias Bigplates.Core.VariantItem

  defstruct name: nil,
            type: nil,
            max_options: 1,
            required: false,
            options: []

  def new(fields) do
    struct!(__MODULE__, fields)
    |> enforce_single_limit(fields)
    |> enforce_multiple_limit(fields)
  end

  def enforce_single_limit(variant, %{type: :multiple} = _fields), do: variant
  def enforce_single_limit(variant, %{type: :single} = fields) do
    variant |> Map.put(:max_options, 1)
  end

  def enforce_multiple_limit(variant, %{type: :single, max_options: _max} = _fields), do: variant
  def enforce_multiple_limit(variant, %{type: :multiple, max_options: max} = _fields) when max >= 2, do: variant
  def enforce_multiple_limit(variant, %{type: :multiple, max_options: max} = fields) when max <= 1 do
    variant |> Map.put(:max_options, 2)
  end

  def add_variant_item(variant, fields) do
    updated_options = [VariantItem.new(fields)] ++ variant.options

    variant |> Map.put(:options, updated_options)
  end

  def add_multiple_variant_items(variant, fields) when is_list(fields) do
    fields
    |> Enum.reduce(variant, &add_variant_item(&2, &1))
  end
end
