defmodule Bigplates.Core.Restaurant.OrderRequirement do
  defstruct minimum_time: 0,
            minimum_order: 0

  def new(%{minimum_time: min_time, minimum_order: min_order} = fields)
      when is_integer(min_time) and is_integer(min_order) do
    struct!(__MODULE__, fields)
  end

  def new(%{minimum_time: _min_time, minimum_order: _min_order} = fields) do
    default_fields = fields |> Map.merge(%{minimum_time: 0, minimum_order: 0})
    struct!(__MODULE__, default_fields)
  end

  def update(
        %__MODULE__{} = order_requirement,
        %{minimum_time: min_time, minimum_order: min_order} = fields
      )
      when is_integer(min_time) and is_integer(min_order) do
    order_requirement
    |> Map.merge(fields)
  end

  def update(%__MODULE__{} = order_requirement, fields) do
    default_fields = fields |> Map.merge(%{minimum_time: 0, minimum_order: 0})

    order_requirement
    |> Map.merge(default_fields)
  end
end
