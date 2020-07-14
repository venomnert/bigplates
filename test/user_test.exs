defmodule UserTest do
  use ExUnit.Case
  use BigplatesBuilder

  describe "creating & updating individual user" do
    test "create new individual user" do
      fields = user_fields()

      User.new(fields)
      |> assert_default_individual_user_fields(fields)
    end

    test "create new individual user with company fields" do
      fields = %{company_name: "Rambuton", company_size: 100} |> user_fields()

      User.new(fields)
      |> assert_default_company_user_fields(fields)
    end

    test "Update individual user profile" do
      updated_fields_1 = %{
        account_type: :individual,
        email_address: "nert@bigplates.com",
        first_name: "Ian",
        last_name: "Kelly",
        phone_number: "4567891230"
      }

      updated_fields_2 = %{
        account_type: :company,
        email_address: "nert@bigplates.com",
        first_name: "Ian",
        last_name: "Kelly",
        phone_number: "4567891230"
      }

      updated_fields_3 = %{
        account_type: :company,
        email_address: "nert@bigplates.com",
        first_name: "Sue",
        last_name: "Kelly",
        phone_number: "1232131231",
        company_name: "Acme",
        company_size: 10
      }

      user_fields()
      |> User.new()
      |> User.update_info(updated_fields_1)
      |> assert_default_individual_user_fields(updated_fields_1)
      |> User.update_info(updated_fields_2)
      |> assert_default_company_user_fields(updated_fields_2)
      |> User.update_info(updated_fields_3)
      |> assert_company_user_fields_with_profile(updated_fields_3)
    end

    # Since this throws an error, should this be handled by Boundry layer?
    test "delete individual user" do
      fields = user_fields()

      deleted_user =
        User.new(fields)
        |> assert_default_individual_user_fields(fields)
        |> User.delete_user()

      assert deleted_user.hidden == true

      # assert_raise FunctionClauseError, fn -> User.delete_user(deleted_user) end
    end
  end

  describe "creating & updating company user" do
    test "create new company user with empty company profile" do
      fields = %{account_type: :company} |> user_fields()

      User.new(fields)
      |> assert_default_company_user_fields(fields)
    end

    test "create new company user with company fields" do
      fields =
        %{account_type: :company, company_name: "Rambuton", company_size: 5000} |> user_fields()

      User.new(fields)
      |> assert_company_user_fields_with_profile(fields)
    end

    # Since this throws an error, should this be handled by Boundry layer?
    test "delete company user" do
      fields =
        %{account_type: :company, company_name: "Rambuton", company_size: 5000} |> user_fields()

      deleted_user =
        User.new(fields)
        |> assert_company_user_fields_with_profile(fields)
        |> User.delete_user()

      assert deleted_user.hidden == true

      # assert_raise FunctionClauseError, fn -> User.delete_user(deleted_user) end
    end

    test "invalid company size" do
      fields_1 =
        %{account_type: :company, company_name: "Rambuton", company_size: 5000} |> user_fields()

      fields_2 =
        %{account_type: :company, company_name: "Rambuton", company_size: "dfasfa"}
        |> user_fields()

      fields_3 =
        %{account_type: :company, company_name: "Rambuton", company_size: "5000"} |> user_fields()

      fields_4 =
        %{account_type: :company, company_name: "Rambuton", company_size: 11.44} |> user_fields()

      user_1 = User.new(fields_1)
      user_2 = User.new(fields_2)
      user_3 = User.new(fields_3)
      user_4 = User.new(fields_4)

      assert user_1.company_size == fields_1.company_size
      assert user_2.company_size == 0
      assert user_3.company_size == 0
      assert user_4.company_size == Kernel.trunc(fields_4.company_size)
    end

    test "Update company user profile" do
      updated_fields_1 = %{
        account_type: :company,
        email_address: "nert@bigplates.com",
        first_name: "Ian",
        last_name: "Kelly",
        phone_number: "4567891230"
      }

      updated_fields_2 = %{
        account_type: :company,
        email_address: "nert@bigplates.com",
        first_name: "Sue",
        last_name: "Kelly",
        phone_number: "1232131231",
        company_name: "Acme",
        company_size: 10
      }

      updated_fields_3 = %{
        account_type: :individual,
        email_address: "nert@bigplates.com",
        first_name: "Ian",
        last_name: "Kelly",
        phone_number: "4567891230"
      }

      user_fields()
      |> User.new()
      |> User.update_info(updated_fields_1)
      |> assert_default_company_user_fields(updated_fields_1)
      |> User.update_info(updated_fields_2)
      |> assert_company_user_fields_with_profile(updated_fields_2)
      |> User.update_info(updated_fields_3)
      |> assert_default_individual_user_fields(updated_fields_3)
    end
  end

  describe "user types" do
    test "Test invalid user types" do
      user_1 = user_fields(%{account_type: nil, company_name: "test"}) |> User.new()

      user_2 =
        user_fields(%{account_type: "fadsfsaf", company_name: "FLS", company_size: 500})
        |> User.new()

      user_3 = user_fields(%{account_type: :test}) |> User.new()

      assert user_1.account_type == :individual
      assert user_2.account_type == :individual
      assert user_3.account_type == :individual

      assert user_1.company_name == nil
      assert user_2.company_name == nil
      assert user_2.company_size == 0
    end
  end

  describe "adding & removing address to user" do
    setup [:user]

    test "Add single address to user", %{user: user} do
      new_address =
        address_fields()
        |> Address.new()

      user_address = user |> User.add_address(new_address) |> Map.get(:address)

      assert Enum.empty?(user_address) == false
    end

    test "Add multiple address to user", %{user: user} do
      [first_address, second_address] = address_generator(2)

      user_addresses =
        user
        |> User.add_address(first_address)
        |> User.add_address(second_address)
        |> Map.get(:address)

      assert length(user_addresses) == 2
    end

    test "Remove existing address from user", %{user: user} do
      new_address = Address.new(address_fields())
      user_address = user |> User.add_address(new_address)

      assert Enum.empty?(user_address.address) == false

      removed_user_address = user_address |> User.delete_address(new_address)

      assert Enum.empty?(removed_user_address.address) == true
    end

    test "Remove unknown address from user", %{user: user} do
      [first_address] = address_generator(1)

      unknown_address =
        address_fields(%{street: "1213 Chimpunk", postal_code: "M1V2L4"}) |> Address.new()

      user_address =
        user
        |> User.add_address(first_address)
        |> User.delete_address(unknown_address)
        |> Map.get(:address)

      assert Enum.empty?(user_address) == false
    end
  end

  defp user(context) do
    user = User.new(create_user())
    {:ok, Map.put(context, :user, user)}
  end

  defp assert_default_individual_user_fields(user, fields) do
    assert fields.account_type == user.account_type
    assert fields.email_address == user.email_address
    assert fields.first_name == user.first_name
    assert fields.last_name == user.last_name
    assert fields.phone_number == user.phone_number
    assert user.company_name == nil
    assert user.company_size == 0
    assert user.hidden == false

    user
  end

  defp assert_default_company_user_fields(user, fields) do
    assert fields.account_type == user.account_type
    assert fields.email_address == user.email_address
    assert fields.first_name == user.first_name
    assert fields.last_name == user.last_name
    assert fields.phone_number == user.phone_number
    assert user.company_name == nil
    assert user.company_size == 0
    assert user.hidden == false
    user
  end

  defp assert_company_user_fields_with_profile(user, fields) do
    assert fields.account_type == user.account_type
    assert fields.email_address == user.email_address
    assert fields.first_name == user.first_name
    assert fields.last_name == user.last_name
    assert fields.phone_number == user.phone_number
    assert fields.company_name == user.company_name
    assert fields.company_size == user.company_size
    assert user.hidden == false
    user
  end
end
