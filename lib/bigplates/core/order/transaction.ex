defmodule Bigplates.Core.Order.Transaction do
  @transaction_type [:add, :subtract]

  defstruct type: nil,
            quantity: nil,
            base_price: nil,
            restaurant: nil,
            menu_item: nil,
            total_price: "calculate_total_price function"

  def create(fields) do
    struct!(__MODULE__, fields)
  end

  # def add_variant(menu_item, fields) do
  # end

  # def calculate_total_price(transaction) do
  # end
end
