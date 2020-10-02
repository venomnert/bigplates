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
            total_items: []

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  def add_item(order, menu_item) do
    {_, updated_order} =
      order
      |> process_order_action(menu_item)
      |> Map.get_and_update(:total_items, &add_to_total_item(&1, menu_item))

    updated_order
  end

  def update_item(order, menu_item) do
  end

  def delete_item(order, menu_item) do
    updated_total_items =
      order
      |> process_order_action(menu_item)
      |> Map.get(:total_items)
      |> Enum.reject(&delete_from_total_item(&1, menu_item))

    order
    |> Map.put(:total_items, updated_total_items)
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

  defp add_to_total_item(menu_items, new_menu_item),
    do: {menu_items, [new_menu_item | menu_items]}

  defp delete_from_total_item(menu_item, old_menu_item),
    do: menu_item == old_menu_item

end
