defmodule Bigplates.Core.Address do
  defstruct ~w[address_hash street city province postal_code special_instructions unit_number]a

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
    postal_code = format_postal_code(fields.postal_code)

    %__MODULE__{
      address_hash: postal_code <> fields.unit_number,
      street: fields.street,
      city: fields.city,
      province: fields.province,
      postal_code: postal_code,
      special_instructions: fields.special_instructions,
      unit_number: fields.unit_number
    }
  end

  def add_unique_address(main_entity, address_field) do
    [__MODULE__.new(address_field)]
    |> Enum.concat(main_entity.address)
    |> Enum.uniq_by(&get_address_hash(&1))
  end

  def remove_address(main_entity, %__MODULE__{} = address_to_remove) do
      main_entity.address
      |> Enum.reject(&is_address_hash_equal(&1, address_to_remove))
  end


  defp get_address_hash(%__MODULE__{} = address), do: address.address_hash

  defp is_address_hash_equal(address_1, address_2), do: address_1.address_hash == address_2.address_hash

  defp format_postal_code(postal_code) do
    postal_code
    |> String.downcase()
    |> String.replace(" ", "")
  end
end
