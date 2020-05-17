defmodule Bigplates.Core.VariantItem do
  defstruct ~w[name price description]a

  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
