defmodule Bigplates.Core.Order do
  @delivery_time_window_minutes [:low, :high]
  @status [:draft, :processing, :paid, :refunded]

  alias Bigplates.Core.MenuItem.ComboItem
  alias Bigplates.Core.MenuItem
  alias Bigplates.Core.Order.{OrderRequirement, DeliveryRequirement}

  defstruct user: nil,
            address: nil,
            meal_categories: nil,
            event: nil,
            num_of_guest: nil,
            item_total: 0,
            total_items: %{},
            order_requirement: %OrderRequirement{},
            delivery_requirement: %DeliveryRequirement{},
            delivery_charge: nil,
            delivery_total: nil,
            sub_total: 0,
            tax_total: 0,
            per_person_total: 0,
            tip_rate: 0,
            tip_total: 0,
            cutlery: false,
            order_date: nil,
            date_ordered: nil,
            delivery_date: nil,
            delivery_time: nil,
            delivery_time_window_minutes: [],
            status: nil,
            valid: false

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  def add_order_item(order, order_item) do
    new_total_items =
      order
      |> Map.get(:total_items)
      |> Map.update(order_item, 1, &(&1 + 1))

    Map.put(order, :total_items, new_total_items)
    |> process_order_action(order_item)
  end

  def reduce_order_item(order, order_item) do
    {_old_total_items, new_order_items} =
      order
      |> Map.get(:total_items)
      |> Map.get_and_update(order_item, &check_and_reduce(&1))

    order
    |> Map.put(:total_items, new_order_items)
    |> process_order_action(order_item)
  end

  def remove_order_item(order, order_item) do
    new_total_items =
      order
      |> Map.get(:total_items)
      |> Map.delete(order_item)

    Map.put(order, :total_items, new_total_items)
    |> process_order_action(order_item)
  end

  def process_order_action(order, {_restaurant, menu_item} = _order_item) do
    order
    |> calculate_total_item()
    # |> calculate_sub_total()
    # |> calculate_tax_total()
    # |> calculate_per_person_total()
    # |> calculate_tip_total()
  end

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

  defp check_and_reduce(qty) when qty == 0, do: :pop
  defp check_and_reduce(qty) when qty > 0, do: {qty, qty - 1}

  def calculate_total_item(%{total_items: total_items} = order) do
    Enum.empty?(total_items)
    |> case do
      true -> Map.put(order, :item_total, 0)
      false ->
        item_total = order
                |> Map.get(:total_items)
                |> Map.values()
                |> Enum.reduce(0, &(&1 + &2))

        Map.put(order, :item_total, item_total)
    end
  end

  def calculate_sub_total() do
    
  end
end
