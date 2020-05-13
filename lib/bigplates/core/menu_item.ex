defmodule Bigplates.Core.MenuItem do

  alias Bigplates.Core.PortionSize

  @price_types [:single, :per_person]

  defstruct name: nil,
            description: nil,
            price_type: nil,
            img: [],
            portion_sizes: %{},
            published: true,
            variants: []

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  def add_portion_size(menu_item, fields) do
    portion_size = PortionSize.new(fields)

    menu_item |> Map.put(portion_size.name, portion_size)
  end

  def add_variant(menu_item, fields) do

  end
end
