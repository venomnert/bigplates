defmodule Bigplates.Core.Admin do
  alias Bigplates.Core.{Address}

  """
    * account_type: [:individual, :company]
    * company_size:[:small, :medium, :large]
    * notification_preference: [:new_order, :update, :ready, :cancelled_order]
    * dietary_preference: [:halal, :egg_free, :dairy_free, :vegan, :gluten_free, :nut_free, :vegetarian]
  """

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

  def add_address(user, fields) do
    updated_address = [Address.new(fields)] ++ user.address

    user |> Map.put(:address, updated_address)
  end

  def add_order(user, order) do
  end

  def add_payment(user, payment) do
  end

  def favourite_menu_item(user, item) do
  end
end
