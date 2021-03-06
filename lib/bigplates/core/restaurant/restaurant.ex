defmodule Bigplates.Core.Restaurant do
  alias Bigplates.Core.{MenuItem, Address}
  alias Bigplates.Utility

  defstruct name: nil,
            cuisine_name: nil,
            menus: [],
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
    updated_menu = [menu_item | restaurant.menus]
    restaurant |> Map.put(:menus, updated_menu)
  end

  def delete_menu_item(restaurant, %MenuItem{} = menu_item) do
    updated_menu =
      restaurant.menus
      |> List.delete(menu_item)

    restaurant |> Map.put(:menus, updated_menu)
  end

  def update_menu_item(restaurant, %MenuItem{} = old_menu_item, %MenuItem{} = new_menu_item) do
    updated_menu = [new_menu_item | List.delete(restaurant.menus, old_menu_item)]
    restaurant |> Map.put(:menus, updated_menu)
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
    updated_address = Address.add_unique_address(restaurant, address, :address)

    restaurant |> Map.put(:address, updated_address)
  end

  @doc """
    Delete existing address from active restaurant
  """
  def delete_address(restaurant, %Address{} = address_to_remove) do
    updated_address = Address.delete_address(restaurant, address_to_remove, :address)

    restaurant |> Map.put(:address, updated_address)
  end

  defp add_slug(restaurant, fields) do
    restaurant
    |> Map.put(:slug, Utility.create_slug(fields.cuisine_name))
  end
end
