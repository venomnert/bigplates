defmodule BigplatesBuilder do
  defmacro __using__(_options) do
    quote do
      alias Bigplates.Core.{User, Address, Restaurant, CuisineType, Menu}
      alias Bigplates.Utility
      import BigplatesBuilder, only: :functions
    end
  end

  alias Bigplates.Core.{User, Address, Restaurant, CuisineType, Menu}

  def menu_fields(overrides \\ %{}) do
    Map.merge(
      %{
        name: "Breakfast",
        meal_category: :breakfast
      },
      overrides
    )
  end

  def restaurant_fields(overrides \\ %{}) do
    Map.merge(
      %{
        name: "TOE"
      },
      overrides
    )
  end

  def restaurant_requirement_fields(overrides \\ %{}) do
    Map.merge(
      %{
        requirements: %{
          minimum_time: 24,
          minimum_order: 300
        }
      },
      overrides
    )
  end

  def restaurant_delivery_fee_fields(overrides \\ %{}) do
    Map.merge(
      %{
        delivery_fee: %{
          fee: 20,
          waive_after: 1000
        }
      },
      overrides
    )
  end

  def cuisinine_fields(overrides \\ %{}) do
    Map.merge(
      %{
        filipino: true,
        greek: true,
        italian: true
      },
      overrides
    )
  end

  def address_fields(overrides \\ %{}) do
    Map.merge(
      %{
        street: "1527 winville rd",
        city: "pickering",
        province: "on",
        postal_code: "l1x 0b8",
        special_instructions: """
        Miusov, as a man man of breeding and deilcacy, could not but feel some inwrd qualms, when he reached the Father Superior's with Ivan: he felt ashamed of havin lost his temper. He felt that he ought to have disdaimed that despicable wretch, Fyodor Pavlovitch, too much to have been upset by him in Father Zossima's cell, and so to have forgotten himself. "Teh monks were not to blame, in any case," he reflceted, on the steps. "And if they're decent people here (and the Father Superior, I understand, is a nobleman) why not be friendly and courteous withthem? I won't argue, I'll fall in with everything, I'll win them by politness, and show them that I've nothing to do with that Aesop, thta buffoon, that Pierrot, and have merely been takken in over this affair, just as they have
        """,
        unit_number: "12A"
      },
      overrides
    )
  end

  def user_fields(overrides \\ %{}) do
    Map.merge(
      %{
        account_type: :individual,
        email_address: "nert@rambuton.com",
        first_name: "nert",
        last_name: "siva",
        phone_number: "1231231231"
      },
      overrides
    )
  end

  def create_user(overrides, address: :single) do
    Map.merge(
      %{address: address_generator(1)},
      overrides
    )
    |> create_user()
  end

  def create_user(overrides, address: :multiple) do
    Map.merge(
      %{address: address_generator(2)},
      overrides
    )
    |> create_user()
  end

  def create_user(overrides \\ %{}) do
    Map.merge(
      %{
        account_type: :individual,
        email_address: "nert@rambuton.com",
        first_name: "nert",
        last_name: "siva",
        phone_number: "1231231231"
      },
      overrides
    )
  end

  def create_restaurant(overrides) when is_map(overrides) do
    Map.merge(
      restaurant_fields(),
      overrides
    )
  end

  def create_restaurant(:no_requirements) do
    %{
      delivery_fee: restaurant_delivery_fee_fields(),
      cuisine_types: CuisineType.new(cuisinine_fields())
    }
    |> create_restaurant()
  end

  def create_restaurant(:no_delivery_fee) do
    %{
      requirements: restaurant_requirement_fields(),
      cuisine_types: CuisineType.new(cuisinine_fields())
    }
    |> create_restaurant()
  end

  def create_restaurant(:no_cuisine_type) do
    %{
      requirements: restaurant_requirement_fields(),
      delivery_fee: restaurant_delivery_fee_fields()
    }
    |> create_restaurant()
  end

  def address_generator(qty) do
    for x <- 1..qty do
      %{
        unit_number: "#{x}A",
        street: "#{x} test rd",
        postal_code: "l#{x}x #{x}b#{x}"
      }
      |> address_fields()
      |> Address.new()
    end
  end
end
