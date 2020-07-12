defmodule Bigplates.Core.VariantItem do
  defstruct ~w[name price description]a

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  def update(variant_item, fields) do
    new_variant_item = fields |> new()

    variant_item |> Map.merge(new_variant_item)
  end
end
