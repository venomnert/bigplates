defmodule Bigplates.Core.MenuItem.ComboItem do
  alias Bigplates.Core.MenuItem

  defstruct name: nil,
            price: nil,
            description: nil,
            cutlery: false,
            savings: nil,
            menu_items: [],
            hidden: false,
            img: []

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  def update_combo_item(combo_item, fields) do
    new_combo_item = fields |> new()
    combo_item |> Map.merge(new_combo_item)
  end

  def add_menu_item(combo_item, %MenuItem{name: name} = menu_item) do
    key = name |> String.to_atom()

    {_, updated_menu_items} =
      combo_item.menu_items
      |> Keyword.get_and_update(key, fn curr ->
        add_item(curr, menu_item)
      end)

    combo_item |> Map.put(:menu_items, updated_menu_items)
  end

  def update_menu_item(combo_item, {:increase, %MenuItem{name: name} = menu_item}) do
    key = name |> String.to_atom()

    case Keyword.has_key?(combo_item.menu_items, key) do
      true ->
        {_, updated_menu_items} =
          combo_item.menu_items
          |> Keyword.get_and_update(key, fn curr ->
            increase_item(curr, menu_item)
          end)

        combo_item |> Map.put(:menu_items, updated_menu_items)

      false ->
        combo_item
    end
  end

  def update_menu_item(combo_item, {:decrease, %MenuItem{name: name} = menu_item}) do
    key = name |> String.to_atom()

    case Keyword.has_key?(combo_item.menu_items, key) do
      true ->
        {_, updated_menu_items} =
          combo_item.menu_items
          |> Keyword.get_and_update(key, fn curr ->
            decrease_item(curr, menu_item)
          end)

        combo_item |> Map.put(:menu_items, updated_menu_items)

      false ->
        combo_item
    end
  end

  def remove_menu_item(combo_item, %MenuItem{name: name} = _menu_item) do
    key = name |> String.to_atom()

    updated_menu_items =
      combo_item.menu_items
      |> Keyword.delete(key)

    combo_item |> Map.put(:menu_items, updated_menu_items)
  end

  def calculate_savings(%{menu_items: []} = combo_item) do
    combo_item
  end

  # Automatica saving calculator will be setup sometime in the future
  # def calculate_savings(combo_item) do
  #   updated_savings = for {_k, v} <- combo_item.menu_items, do: v.price
  #   IO.inspect(updated_savings, label: "TEST")
  # end

  defp add_item(nil, menu_item) do
    {nil, {menu_item, 1}}
  end

  defp add_item(curr, _menu_item) do
    {curr, curr}
  end

  defp increase_item({_curr_item, qty} = curr, _menu_item) do
    {curr, {curr, qty + 1}}
  end

  defp decrease_item({_curr_item, 1} = curr, _menu_item) do
    :pop
  end

  defp decrease_item({_curr_item, qty} = curr, _menu_item) do
    {curr, {curr, qty - 1}}
  end
end
