defmodule Bigplates.Core.Order do
  """
    * delivery_time_window_minutes: [low, high]
    * status: [:draft, :paid, :refunded]

  """

  defstruct user: nil,
            address: nil,
            item_total: nil,
            delivery_total: nil,
            sub_total: nil,
            delivery_charge: nil,
            tax_total: nil,
            per_person_total: nil,
            tip_rate: nil,
            tip_total: nil,
            cutlery: false,
            order_date: nil,
            status: nil,
            date_ordered: nil,
            delivery_date: nil,
            delivery_time: nil,
            delivery_time_window_minutes: [],
            event: nil,
            num_of_guest: nil,
            transactions: [],
            total_items: []

  def create(fields) do
    struct!(__MODULE__, fields)
  end
end
