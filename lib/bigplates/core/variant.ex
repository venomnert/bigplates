defmodule Bigplates.Core.Variant do

  @type [:single, :multiple]

  """
    * type: [:single, :multiple]
    * options: %{
        values: %{key1 => value1,...,keyN=>valueN}
      }
  """

  defstruct name: nil,
            type: nil,
            options: %{
              values: %{},
              max_options: 1
            },
            required: false

  def new(fields) do
    struct!(__MODULE__, fields)
    |> enforce_single_limit()
    |> add_required()
  end

  def enforce_single_limit(variant, fields) do

  end

  def add_required(variant, fields) do
    
  end
end
