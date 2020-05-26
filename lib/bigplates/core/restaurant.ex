defmodule Bigplates.Core.Restaurant do
  alias Bigplates.Core.{CuisineType, Menu}
  alias Bigplates.Utility

  defstruct name: nil,
            requirements: %{
              minimum_time: 0,
              minimum_order: 0,
            },
            delivery_fee: %{
              fee: 0,
              waive_after: 0
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
    |> validate_requirements()
    |> validate_delivery_fee()
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

  defp validate_requirements(restaurant) do
    normalized_string = Utility.normalized_string(restaurant.requirements)
    normalized_nil = Utility.normalized_nil(restaurant.requirements)

    updated_requirements =
      restaurant.requirements
      |> Map.merge(normalized_string)
      |> Map.merge(normalized_nil)

    restaurant
    |> Map.put(:requirements, updated_requirements)
  end

  defp validate_delivery_fee(%{delivery_fee: delivery_fee} = requirements) do
    normalized_string = Utility.normalized_string(delivery_fee)
    normalized_nil = Utility.normalized_nil(delivery_fee)

    updated_delivery_fee =
      requirements.delivery_fee
      |> Map.merge(normalized_string)
      |> Map.merge(normalized_nil)

    requirements
    |> Map.put(:delivery_fee, updated_delivery_fee)
  end
end
