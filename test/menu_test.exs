defmodule MenuTest do
  use ExUnit.Case
  use BigplatesBuilder

  describe "create & update menu" do
    test "create menu" do
      menu_field = menu_fields()

      menu_field
      |> Menu.new()
      |> assert_menu(menu_field)
    end

    test "update full menu" do
      menu_field_1 = menu_fields()
      menu_field_2 = menu_fields(%{name: "Lunch Special", meal_category: :lunch})

      menu_field_1
      |> Menu.new()
      |> assert_menu(menu_field_1)
      |> Menu.update_menu(menu_field_2)
      |> assert_menu(menu_field_2)
    end

    test "update single menu" do
      menu_field_1 = menu_fields()
      menu_field_2 = menu_fields(%{name: "Lunch Special"})

      menu_field_1
      |> Menu.new()
      |> assert_menu(menu_field_1)
      |> Menu.update_menu(menu_field_2)
      |> assert_menu(menu_field_2)
    end
  end

  describe "test menu category" do
    test "invalid category" do
      menu_field = menu_fields(%{name: "testing dfdsaf !@#!", meal_category: :brunch})

      menu_field
      |> Menu.new()
      |> assert_menu_category(menu_field)
    end
  end

  defp assert_menu(menu, fields) do
    assert fields.name == menu.name
    assert fields.meal_category == menu.meal_category
    assert Utility.create_slug(fields.name) == menu.slug
    menu
  end

  defp assert_menu_category(menu, fields) do
    assert fields.name == menu.name
    assert menu.meal_category == nil
    assert Utility.create_slug(fields.name) == menu.slug
    menu
  end
end
