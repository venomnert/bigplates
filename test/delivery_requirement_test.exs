defmodule DeliveryRequirementTest do
  use ExUnit.Case
  use BigplatesBuilder

  # describe "adding & updating delivery fee" do
  #   setup [:order]

  #   test "Add delivery fee to order", %{order: order} do
  #     fields = %{
  #       fee: 50,
  #       waive_after: 100
  #     }

  #     order
  #     |> Order.update_delivery_requirement(fields)
  #     |> assert_delivery_requirement(fields)
  #   end

  #   test "Update delivery fee to order", %{order: order} do
  #     fields_1 = %{
  #       fee: 10,
  #       waive_after: 500
  #     }

  #     fields_2 = %{
  #       fee: 500,
  #       waive_after: 250
  #     }

  #     order
  #     |> Order.update_delivery_requirement(fields_1)
  #     |> assert_delivery_requirement(fields_1)
  #     |> Order.update_delivery_requirement(fields_2)
  #     |> assert_delivery_requirement(fields_2)
  #   end

  #   test "Invalid delivery fee to order", %{order: order} do
  #     fields_1 = %{
  #       fee: "dfasfa",
  #       waive_after: nil
  #     }

  #     order
  #     |> Order.update_delivery_requirement(fields_1)
  #     |> assert_delivery_requirement(@default_delivery_requirement)
  #   end
  # end

  defp assert_delivery_requirement(order, fields) do
    delivery_requirement = Map.from_struct(order.delivery_requirement)
    assert Map.equal?(delivery_requirement, fields) == true
    order
  end
end
