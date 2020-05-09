defmodule Bigplates.Core.PortionSize do

  """
    * serving_range: [lower, higher]

    1. small: 1 - 8 people
    2. medium: 8 - 15 people
    3. large: 15 - 25 people
  """

  defstruct serving_size: nil,
            serving_range: [],
            description: nil

  def new(fields) do
    struct!(__MODULE__, fields)
  end

end
