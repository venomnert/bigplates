defmodule Bigplates.Core.Restaurant do
  alias Bigplates.Core.Restaurant.{OrderRequirement, DeliveryRequirement}
  alias Bigplates.Core.{CuisineType, MenuItem, Address}
  alias Bigplates.Utility

  defstruct name: nil,
            cuisine_name: nil,
            order_requirement: %OrderRequirement{},
            delivery_requirement: %DeliveryRequirement{},
            menus: %{},
            payouts: [],
            orders: [],
            address: [],
            payments: [],
            hidden: false,
            slug: nil

  def new(fields) do
    struct!(__MODULE__, fields)
    |> add_slug(fields)
  end

  def update_info(restaurant, fields) do
    restaurant
    |> Map.merge(fields)
    |> add_slug(fields)
  end

  def add_menu_item(restaurant, %MenuItem{} = menu_item) do
    menus =
      restaurant.menus
      |> put_in(
        [{menu_item.category, menu_item.name}],
        menu_item
      )

    restaurant |> Map.put(:menus, menus)
  end

  defp add_to_list_or_nil(nil, menu_item), do: [menu_item]
  defp add_to_list_or_nil(menu_items, menu_item), do: [menu_item | menu_items]

  def delete_menu_item(restaurant, %MenuItem{} = menu_item) do
    restaurant.menus
    |> Enum.empty?()
    |> case do
      true ->
        restaurant

      false ->
        updated_menu =
          restaurant.menus
          |> Map.delete({menu_item.category, menu_item.name})

        restaurant |> Map.put(:menus, updated_menu)
    end
  end

  @doc """
    Soft delete restaurant
  """
  def delete_restaurant(%{hidden: false} = restaurant) do
    restaurant |> Map.put(:hidden, true)
  end

  @doc """
    Add new address to active restaurant
  """
  def add_address(restaurant, %Address{} = address) do
    updated_address = Address.add_unique_address(restaurant, address)

    restaurant |> Map.put(:address, updated_address)
  end

  @doc """
    Delete existing address from active restaurant
  """
  def delete_address(restaurant, %Address{} = address_to_remove) do
    updated_address = Address.delete_address(restaurant, address_to_remove)

    restaurant |> Map.put(:address, updated_address)
  end

  def add_order_requirement(restaurant, fields) do
    order_requirement = OrderRequirement.new(fields)

    restaurant |> Map.put(:order_requirement, order_requirement)
  end

  def update_order_requirement(restaurant, fields) do
    updated_order_requirement = restaurant.order_requirement |> OrderRequirement.update(fields)

    restaurant |> Map.put(:order_requirement, updated_order_requirement)
  end

  def add_delivery_requirement(restaurant, fields) do
    delivery_requirement = DeliveryRequirement.new(fields)

    restaurant |> Map.put(:delivery_requirement, delivery_requirement)
  end

  def update_delivery_requirement(restaurant, fields) do
    updated_delivery_requirement = restaurant.delivery_requirement |> DeliveryRequirement.update(fields)

    restaurant |> Map.put(:delivery_requirement, updated_delivery_requirement)
  end

  defp add_slug(restaurant, fields) do
    restaurant
    |> Map.put(:slug, Utility.create_slug(fields.cuisine_name))
  end
end
