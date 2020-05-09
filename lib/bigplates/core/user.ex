defmodule Bigplates.Core.User do
  alias Bigplates.Core.{Address}

  @account_type [:individual, :company]
  @company_size [:small, :medium, :large]

  defstruct account_type: nil,
            email_address: nil,
            first_name: nil,
            last_name: nil,
            phone_number: nil,
            company_name: nil,
            company_type: nil,
            company_size: nil,
            dietary_preference: [],
            notification_preference: [],
            favourite_menu_items: [],
            address: [],
            payments: [],
            orders: []

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  def update_info(user, fields) do
    user
    |> struct!(fields)
  end

  def add_address(user, address_field) do
    updated_address = Address.add_unique_address(user, address_field)

    user |> Map.put(:address, updated_address)
  end

  def remove_address(user, %Address{} = address_to_remove) do
    updated_address = Address.remove_address(user, address_to_remove)

    user |> Map.put(:address, updated_address)
  end

  def add_order(user, order) do
  end

  def add_payment(user, payment) do
  end

  def favourite_menu_item(user, item) do
  end
end
