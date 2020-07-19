defmodule Bigplates.Example do
  alias Bigplates.Core.{User, Restaurant, Variant, PortionSize, MenuItem, ComboItem}
  alias Bigplates.Core.Message.{MessageType}

  def create_users(:individual) do
    first_add = %{
      street: "1527 winville rd",
      city: "pickering",
      province: "on",
      postal_code: "l1x 0b8",
      special_instructions: """
      Miusov, as a man man of breeding and deilcacy, could not but feel some inwrd qualms, when he reached the Father Superior's with Ivan: he felt ashamed of havin lost his temper. He felt that he ought to have disdaimed that despicable wretch, Fyodor Pavlovitch, too much to have been upset by him in Father Zossima's cell, and so to have forgotten himself. "Teh monks were not to blame, in any case," he reflceted, on the steps. "And if they're decent people here (and the Father Superior, I understand, is a nobleman) why not be friendly and courteous withthem? I won't argue, I'll fall in with everything, I'll win them by politness, and show them that I've nothing to do with that Aesop, thta buffoon, that Pierrot, and have merely been takken in over this affair, just as they have
      """,
      unit_number: nil
    }
    second_add = %{
      street: "6 chimpunk rd",
      city: "scarborough",
      province: "on",
      postal_code: "l1x 0b8",
      special_instructions: """
      he felt ashamed of havin lost his temper. He felt that he ought to have disdaimed that despicable wretch, Fyodor Pavlovitch, too much to have been upset by him in Father Zossima's cell, and so to have forgotten himself. "Teh monks were not to blame, in any case," he reflceted, on the steps. "And if they're decent people here (and the Father Superior, I understand, is a nobleman) why not be friendly and courteous withthem? I won't argue, I'll fall in with everything, I'll win them by politness, and show them that I've nothing to do with that Aesop, thta buffoon, that Pierrot, and have merely been takken in over this affair, just as they have
      """,
      unit_number: "1231"
    }

    %{
      account_type: :individual,
      email_address: "nert@rambuton.com",
      first_name: "nert",
      last_name: "siva",
      phone_number: "1231231231",
    }
    |> User.new()
    |> User.add_address(first_add)
    |> User.add_address(second_add)
  end

  def create_users(:company) do
    first_add = %{
      street: "1527 winville rd",
      city: "pickering",
      province: "on",
      postal_code: "l1x 0b8",
      special_instructions: """
      Miusov, as a man man of breeding and deilcacy, could not but feel some inwrd qualms, when he reached the Father Superior's with Ivan: he felt ashamed of havin lost his temper. He felt that he ought to have disdaimed that despicable wretch, Fyodor Pavlovitch, too much to have been upset by him in Father Zossima's cell, and so to have forgotten himself. "Teh monks were not to blame, in any case," he reflceted, on the steps. "And if they're decent people here (and the Father Superior, I understand, is a nobleman) why not be friendly and courteous withthem? I won't argue, I'll fall in with everything, I'll win them by politness, and show them that I've nothing to do with that Aesop, thta buffoon, that Pierrot, and have merely been takken in over this affair, just as they have
      """,
      unit_number: nil
    }
    second_add = %{
      street: "6 chimpunk rd",
      city: "scarborough",
      province: "on",
      postal_code: "l1x 0b8",
      special_instructions: """
      he felt ashamed of havin lost his temper. He felt that he ought to have disdaimed that despicable wretch, Fyodor Pavlovitch, too much to have been upset by him in Father Zossima's cell, and so to have forgotten himself. "Teh monks were not to blame, in any case," he reflceted, on the steps. "And if they're decent people here (and the Father Superior, I understand, is a nobleman) why not be friendly and courteous withthem? I won't argue, I'll fall in with everything, I'll win them by politness, and show them that I've nothing to do with that Aesop, thta buffoon, that Pierrot, and have merely been takken in over this affair, just as they have
      """,
      unit_number: "1231"
    }

    %{
      account_type: :company,
      email_address: "admin@acme.com",
      first_name: "Kelly",
      last_name: "Smith",
      phone_number: "1231231231",
      phone_number_ext: "890",
      company_name: "Acme",
      company_size: 30,
    }
    |> User.new()
    |> User.add_address(first_add)
    |> User.add_address(second_add)
  end

  def create_restaurants() do
    first_add = %{
      street: "16 dundas rd",
      city: "toronto",
      province: "on",
      postal_code: "m1x 0b8",
      unit_number: "31B"
    }

    %{
      name: "TOE",
      requirements: %{
        minimum_time: 24,
        minimum_order: 300,
      },
      delivery_fee: %{
        fee: 20,
        waive_after: 1000
      },
      cuisine_types: [thai: true, indian: true],
    }
    |> Restaurant.new()
    |> Restaurant.add_address(first_add)
  end

  def create_menu_item(:single) do
    portion_size_1 = %{name: :small, price: 50} |> PortionSize.new()
    portion_size_2 = %{name: :medium, price: 50, sale_price: 10} |> PortionSize.new()

    variant_item_1 = %{name: "Standard Sub", type: :single, max_options: 1, required: true}
    variant_items = [
      %{
        name: "Virginia Honey Ham \u0026 Smoked Turkey Breast",
        price: 13,
        description: "HMMM yummmy"
      },
      %{
        name: "Premium Roast Beef \u0026 Smoked Turkey Breast",
        price: 0,
        description: "What is this thing you are talkinga bout"
      }
    ]

    %{
      name: "Burger",
      category: :lunch,
      description: "Our famous burger. Customize it to your preference.",
      price_type: :single
    }
    |> MenuItem.new()
    |> MenuItem.add_portion_size(portion_size_1)
    |> MenuItem.add_portion_size(portion_size_2)
    |> MenuItem.add_variant({variant_item_1, variant_items})
  end

  # def create_combo_item() do
  #   menu_item_1 = create_menu_item()

  #   ComboItem.new(%{
  #     name: "Family Combo",
  #     price: 50,
  #     sale_price: 30,
  #     description: "Great for family lunch",
  #     cutlery: true
  #   })
  #   |> ComboItem.add_menu_item(menu_item_1)
  #   |> ComboItem.add_menu_item(menu_item_1)
  #   |> ComboItem.add_portion_size(%{
  #     name: "small",
  #     price: 51,
  #     sale_price: 0,
  #     min: 1,
  #     max: 8,
  #     min_order: 1
  #   })
  # end

  # def create_portion_sizes() do
  #   [
  #     %{name: "small", price: 51, sale_price: 0, min: 1, max: 8, min_order: 1},
  #     %{name: "medium", price: 75, sale_price: 0, min: 9, max: 15, min_order: 1},
  #     %{name: "large", price: 100, sale_price: 0, min: 16, max: 25, min_order: 1}
  #   ]
  #   |> Enum.map(&PortionSize.new(&1))
  # end

end
