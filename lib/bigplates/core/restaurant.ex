defmodule Bigplates.Core.Restaurant do
  alias Bigplates.Core.{CuisineType, Menu}
  alias Bigplates.Utility

  defstruct name: nil,
            requirements: %{
              minimum_time: nil,
              minimum_order: nil,
              delivery_fee: %{
                fee: nil,
                waive_after: nil
              }
            },
            menus: MapSet.new(),
            cuisine_types: %CuisineType{},
            payouts: [],
            orders: [],
            address: [],
            payments: [],
            slug: nil

  def new(fields) do
    struct!(__MODULE__, fields)
    |> add_cuisine(fields)
    |> add_slug(fields)
  end

  def update_info(restaurant, fields) do
    restaurant
    |> struct!(fields)
  end

  def add_cuisine(restaurant, fields) do
    restaurant
    |> Map.put(:cuisine_types, CuisineType.new(fields.cuisine_types))
  end

  def add_menu(restaurant, fields) do
    updated_menus = restaurant.menus |> MapSet.put(Menu.new(fields))

    restaurant |> Map.put(:menus, updated_menus)
  end

  def remove_menu(restaurant, fields) do
    updated_menus = restaurant.menus |> MapSet.delete(Menu.new(fields))

    restaurant |> Map.put(:menus, updated_menus)
  end

  defp check_if_item_is_same(item_a, item_b, keyword) do
    get_in(item_a, [keyword]) == get_in(item_b, [keyword])
  end

  defp add_slug(restaurant, fields) do
    restaurant
    |> Map.put(:slug, Utility.create_slug(fields.name))
  end
end
