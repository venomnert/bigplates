defmodule Bigplates.Core.MenuItem.VariantOption do
  defstruct ~w[name price description]a

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  def update(variant_option, fields) do
    new_variant_option = fields |> new()

    variant_option |> Map.merge(new_variant_option)
  end
end
