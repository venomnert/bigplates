defmodule OrderRequirementTest do
  use ExUnit.Case
  use BigplatesBuilder

  # describe "adding & updating requirements" do
  #   setup [:order]

  #   test "Add requirement to order", %{order: order} do
  #     fields = %{
  #       minimum_time: 24,
  #       minimum_order: 300
  #     }

  #     order
  #     |> Order.update_order_requirement(fields)
  #     |> assert_order_requirements(fields)
  #   end

  #   test "Update requirement to order", %{order: order} do
  #     fields_1 = %{
  #       minimum_time: 24,
  #       minimum_order: 300
  #     }

  #     fields_2 = %{
  #       minimum_time: 12,
  #       minimum_order: 100
  #     }

  #     order
  #     |> Order.update_order_requirement(fields_1)
  #     |> assert_order_requirements(fields_1)
  #     |> Order.update_order_requirement(fields_2)
  #     |> assert_order_requirements(fields_2)
  #   end

  #   test "Invalid requirement to order", %{order: order} do
  #     fields_1 = %{
  #       minimum_time: 24,
  #       minimum_order: 300
  #     }

  #     fields_2 = %{
  #       minimum_time: nil,
  #       minimum_order: "fdsafa"
  #     }

  #     order
  #     |> Order.update_order_requirement(fields_1)
  #     |> assert_order_requirements(fields_1)
  #     |> Order.update_order_requirement(fields_2)
  #     |> assert_order_requirements(@default_order_requirement)
  #   end
  # end

  defp assert_order_requirements(order, fields) do
    order_requirement = Map.from_struct(order.order_requirement)
    assert Map.equal?(order_requirement, fields) == true
    order
  end
end
