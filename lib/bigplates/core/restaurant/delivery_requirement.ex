defmodule Bigplates.Core.Restaurant.DeliveryRequirement do
  defstruct fee: 0,
            waive_after: 0

  def new(%{fee: fee, waive_after: waive_after} = fields)
      when is_integer(fee) and is_integer(waive_after) do
    struct!(__MODULE__, fields)
  end

  def new(%{fee: _fee, waive_after: _waive_after} = fields) do
    default_fields = fields |> Map.merge(%{fee: 0, waive_after: 0})
    struct!(__MODULE__, default_fields)
  end

  def update(
        %__MODULE__{} = order_requirement,
        %{fee: fee, waive_after: waive_after} = fields
      )
      when is_integer(fee) and is_integer(waive_after) do
    order_requirement
    |> Map.merge(fields)
  end

  def update(%__MODULE__{} = order_requirement, fields) do
    default_fields = fields |> Map.merge(%{fee: 0, waive_after: 0})

    order_requirement
    |> Map.merge(default_fields)
  end
end
