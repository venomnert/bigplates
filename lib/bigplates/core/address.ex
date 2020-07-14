defmodule Bigplates.Core.Address do
  @moduledoc """
    Address is used to store location information for Bigplates.Core.User and Bigplates.Core.Restaurant.
  """

  defstruct ~w[address_hash street city province postal_code special_instructions unit_number]a

  @doc """
    Create a new address with formatted postal code

    ## Examples
      alias Bigplates.Core.Address
      %{
        street: "1527 winville rd",
        city: "pickering",
        province: "on",
        postal_code: "l1x 0b8",
        special_instructions: \"""
        Miusov, as a man man of breeding and deilcacy, could not but feel some inwrd qualms, when he reached the Father Superior's with Ivan: he felt ashamed of havin lost his temper. He felt that he ought to have disdaimed that despicable wretch, Fyodor Pavlovitch, too much to have been upset by him in Father Zossima's cell, and so to have forgotten himself. "Teh monks were not to blame, in any case," he reflceted, on the steps. "And if they're decent people here (and the Father Superior, I understand, is a nobleman) why not be friendly and courteous withthem? I won't argue, I'll fall in with everything, I'll win them by politness, and show them that I've nothing to do with that Aesop, thta buffoon, that Pierrot, and have merely been takken in over this affair, just as they have
        \""",
        unit_number: "12A"
      }
      |> Address.new()
  """
  def new(%{unit_number: nil} = fields) do
    postal_code = format_postal_code(fields.postal_code)

    %__MODULE__{
      address_hash: postal_code <> Atom.to_string(nil),
      street: fields.street,
      city: fields.city,
      province: fields.province,
      postal_code: postal_code,
      special_instructions: fields.special_instructions,
      unit_number: fields.unit_number
    }
  end

  def new(fields) do
    formatted_postal_code = format_postal_code(fields.postal_code)
    address_hash = generate_address_hash(formatted_postal_code, fields.unit_number)

    %__MODULE__{
      address_hash: address_hash,
      street: fields.street,
      city: fields.city,
      province: fields.province,
      postal_code: formatted_postal_code,
      special_instructions: fields.special_instructions,
      unit_number: fields.unit_number
    }
  end

  def add_unique_address(main_entity, %__MODULE__{} = address) do
    [address]
    |> Enum.concat(main_entity.address)
    |> Enum.uniq_by(&get_address_hash(&1))
  end

  def delete_address(main_entity, %__MODULE__{} = address_to_remove) do
    main_entity.address
    |> Enum.reject(&is_address_hash_equal(&1, address_to_remove))
  end

  def generate_address_hash(postal_code, unit_number), do: postal_code <> unit_number

  def get_address_hash(%__MODULE__{} = address), do: address.address_hash

  def is_address_hash_equal(address_1, address_2),
    do: address_1.address_hash == address_2.address_hash

  def format_postal_code(postal_code) do
    postal_code
    |> String.downcase()
    |> String.replace(" ", "")
  end
end
