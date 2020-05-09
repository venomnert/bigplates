defmodule Bigplates.Core.Restaurant do
  alias Bigplates.Core.{CuisineType}

  defstruct name: nil,
            requirements: %{
              minimum_time: nil,
              minimum_order: nil,
              delivery_fee: %{
                fee: nil,
                waive_after: nil
              }
            },
            menus: [],
            cuisine_types: %CuisineType{},
            payouts: [],
            orders: [],
            address: [],
            payments: [],
            published: true,
            slug: nil

  def new(fields) do
    struct!(__MODULE__, fields)
    |> add_cuisine(fields)
  end

  def update_info(restaurant, fields) do
    restaurant
    |> struct!(fields)
  end

  def add_cuisine(restaurant, fields) do
    restaurant
    |> Map.put(:cuisine_types, CuisineType.new(fields.cuisine_types))
  end

  def add_menu() do
  end

  def remove_menu() do
  end
end
