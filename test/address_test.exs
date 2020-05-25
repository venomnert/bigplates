defmodule AddressTest do
  use ExUnit.Case
  use BigplatesBuilder

  test "create new address" do
    fields = address_fields()
    address = Address.new(fields)

    assert fields.street == address.street
    assert fields.city == address.city
    assert fields.province == address.province
    assert get_formatted_postal_code(fields) == address.postal_code
    assert fields.special_instructions == address.special_instructions
    assert fields.unit_number == address.unit_number

    assert get_address_hash(fields) == address.address_hash
  end

  defp get_address_hash(fields) do
    fields.postal_code
    |> Address.format_postal_code()
    |> Address.generate_address_hash(fields.unit_number)
  end

  defp get_formatted_postal_code(fields) do
    fields.postal_code
    |> Address.format_postal_code()
  end
end
