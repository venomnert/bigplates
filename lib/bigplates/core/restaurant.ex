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
            menus: %{},
            cuisine_types: %CuisineType{},
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
    |> struct!(fields)
  end

  def add_cuisine(restaurant, %CuisineType{} = cuisine_types) do
    restaurant
    |> Map.put(:cuisine_types, cuisine_types)
  end

  def update_cuisine(restaurant, fields) do
    updated_cuisine_types =
      restaurant |> Map.get(:cuisine_types, %CuisineType{}) |> struct!(fields)

    restaurant
    |> Map.put(:cuisine_types, updated_cuisine_types)
  end

  def add_menu(restaurant, fields) do
    new_menu = Menu.new(fields)
    updated_menus = restaurant.menus |> Map.put(new_menu.slug, new_menu)
    restaurant |> Map.put(:menus, updated_menus)
  end

  def remove_menu(restaurant, %{name: name} = fields) do
    slug = Utility.create_slug(name)
    updated_menus = restaurant.menus |> Map.delete(slug)
    restaurant |> Map.put(:menus, updated_menus)
  end

  def remove_menu(restaurant, %{slug: slug} = fields) do
    updated_menus = restaurant.menus |> Map.delete(slug)
    restaurant |> Map.put(:menus, updated_menus)
  end

  @doc """
    Soft delete restaurant
  """
  def delete_restaurant(%{hidden: false} = restaurant) do
    restaurant |> Map.put(:hidden, true)
  end

  defp add_slug(restaurant, fields) do
    restaurant
    |> Map.put(:slug, Utility.create_slug(fields.name))
  end
end
