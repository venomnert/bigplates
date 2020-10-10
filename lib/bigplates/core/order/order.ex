defmodule Bigplates.Core.Order do
  @delivery_time_window_minutes [:low, :high]
  @status [:draft, :processing, :paid, :refunded]

  alias Bigplates.Core.MenuItem.ComboItem
  alias Bigplates.Core.MenuItem
  alias Bigplates.Core.Order.{OrderRequirement, DeliveryRequirement}

  defstruct user: nil,
            address: nil,
            event: nil,
            num_of_guest: nil,
            delivery_total: nil,
            sub_total: nil,
            order_requirement: %OrderRequirement{},
            delivery_requirement: %DeliveryRequirement{},
            delivery_charge: nil,
            tax_total: nil,
            per_person_total: nil,
            tip_rate: nil,
            tip_total: nil,
            cutlery: false,
            order_date: nil,
            status: nil,
            valid: false,
            date_ordered: nil,
            delivery_date: nil,
            delivery_time: nil,
            delivery_time_window_minutes: [],
            transactions: [],
            item_total: nil,
            total_items: %{}

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  def add_order_item(order, order_item) do
    new_total_items =
      order
      |> Map.get(:total_items)
      |> Map.update(order_item, 1, &(&1+ 1))

    Map.put(order, :total_items, new_total_items)
  end

  def reduce_order_item(order, order_item) do
    {_old_total_items, new_order_items} =
      order
      |> Map.get(:total_items)
      |> Map.get_and_update(order_item, &check_and_reduce(&1))

    order
    |> Map.put(:total_items, new_order_items)
  end

  def remove_order_item(order, order_item) do
    new_total_items =
      order
      |> Map.get(:total_items)
      |> Map.delete(order_item)

    Map.put(order, :total_items, new_total_items)
  end

  def process_order_action(order, menu_item) do
    order
    |> validate_order(menu_item)
    |> calculate_total_item()
    |> calculate_sub_total()
  end

  def validate_order(order, menu_item), do: order

  def add_order_requirement(order, fields) do
    order_requirement = OrderRequirement.new(fields)

    order |> Map.put(:order_requirement, order_requirement)
  end

  def update_order_requirement(order, fields) do
    updated_order_requirement = order.order_requirement |> OrderRequirement.update(fields)

    order |> Map.put(:order_requirement, updated_order_requirement)
  end

  def add_delivery_requirement(order, fields) do
    delivery_requirement = DeliveryRequirement.new(fields)

    order |> Map.put(:delivery_requirement, delivery_requirement)
  end

  def update_delivery_requirement(order, fields) do
    updated_delivery_requirement =
      order.delivery_requirement |> DeliveryRequirement.update(fields)

    order |> Map.put(:delivery_requirement, updated_delivery_requirement)
  end

  def calculate_total_item(%{valid: true} = order), do: order
  def calculate_total_item(%{valid: false} = order), do: order

  def calculate_sub_total(%{valid: true} = order), do: order
  def calculate_sub_total(%{valid: false} = order), do: order

  defp check_and_reduce(qty) when qty == 0, do: :pop
  defp check_and_reduce(qty) when qty > 0, do: {qty, qty - 1}


end
