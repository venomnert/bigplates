defmodule Bigplates.Core.Message.MessageType do
  @message_type [:new_order, :update, :ready, :cancelled_order]

  defstruct message_type: nil

  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
