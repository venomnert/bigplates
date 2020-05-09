defmodule Bigplates.Core.Variant do
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

  def create(fields) do
    struct!(__MODULE__, fields)
  end
end
