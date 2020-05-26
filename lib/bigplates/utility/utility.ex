defmodule Bigplates.Utility do
  def create_slug(string) do
    string
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9\s-]/, "")
    |> String.replace(~r/(\s|-)+/, "-")
  end

  def normalized_string(to_normalize) when is_map(to_normalize) do
    for {k, v} <- to_normalize, is_binary(v), into: %{} do
      {k, 0}
    end
  end

  def normalized_nil(to_normalize) when is_map(to_normalize) do
    for {k, v} <- to_normalize, is_nil(v), into: %{} do
      {k, 0}
    end
  end
end
