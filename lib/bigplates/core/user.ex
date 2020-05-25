defmodule Bigplates.Core.User do
  alias Bigplates.Core.{Address}

  @account_type [:individual, :company]
  @enforce_keys [:account_type]

  defstruct account_type: nil,
            email_address: nil,
            first_name: nil,
            last_name: nil,
            phone_number: nil,
            company_name: nil,
            company_size: 0,
            dietary_preference: [],
            notification_preference: [],
            favourite_menu_items: [],
            address: [],
            payments: [],
            orders: [],
            hidden: false

  @doc """
    Create a new user with user type :company

    ## Examples
    alias Bigplates.Core.User
    %{
      account_type: :company
      email_address: "test@personal.com",
      first_name: "Ian",
      last_name: "Kelly",
      phone_number: "1231231231",
      company_name: "Acme",
      company_size: 100
    }
    |> User.new()
  """
  def new(%{account_type: :company} = fields) do
    struct!(__MODULE__, fields)
    |> validate_company_size()
  end

  @doc """
    Create a new user with user type :individual

    ## Examples
    alias Bigplates.Core.User
    %{
      account_type: :individual
      email_address: "test@personal.com",
      first_name: "Ian",
      last_name: "Kelly",
      phone_number: "1231231231"
    }
    |> User.new()
  """
  def new(%{account_type: :individual} = fields) do
    updated_fields = clean_company_data(fields)
    struct!(__MODULE__, updated_fields)
  end

  @doc """
    Create a new user with user type being :individual by default

    ## Examples
    alias Bigplates.Core.User
    %{
      email_address: "test@personal.com",
      first_name: "Ian",
      last_name: "Kelly",
      phone_number: "1231231231"
    }
    |> User.new()
  """
  def new(%{account_type: _} = fields) do
    updated_fields = clean_company_data(fields) |> Map.put(:account_type, :individual)
    new(updated_fields)
  end

  @doc """
    Update active user info
  """
  def update_info(%{hidden: false} = user, fields) do
    updated_fields = clean_company_data(fields)

    user
    |> struct!(updated_fields)
  end

  @doc """
    Soft delete users
  """
  def delete_user(%{hidden: false} = user) do
    user |> Map.put(:hidden, true)
  end

  @doc """
    Add new address to active users
  """
  def add_address(%{hidden: false} = user, %Address{} = address) do
    updated_address = Address.add_unique_address(user, address)

    user |> Map.put(:address, updated_address)
  end

  @doc """
    Delete existing address from active users
  """
  def remove_address(%{hidden: false} = user, %Address{} = address_to_remove) do
    updated_address = Address.remove_address(user, address_to_remove)

    user |> Map.put(:address, updated_address)
  end

  def add_order(%{hidden: false} = user, order) do
  end

  def add_payment(%{hidden: false} = user, payment) do
  end

  def favourite_menu_item(%{hidden: false} = user, item) do
  end

  defp clean_company_data(%{account_type: :company} = fields), do: fields

  defp clean_company_data(%{account_type: _} = fields) do
    Map.merge(fields, %{company_name: nil, company_size: 0})
  end

  defp validate_company_size(%{company_size: company_size} = user) do
    updated_company_size =
      cond do
        is_binary(company_size) -> 0
        nil -> 0
        is_float(company_size) -> Kernel.trunc(company_size)
        is_integer(company_size) -> company_size
      end

    user |> Map.put(:company_size, updated_company_size)
  end
end
