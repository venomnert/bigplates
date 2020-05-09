defmodule Bigplates.Core.Message do

  defstruct message: nil,
            type: nil,
            order: nil,
            args: []

  def create(fields) do
    struct!(__MODULE__, fields)
  end

end
