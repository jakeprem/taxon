defmodule Taxon.Utils do
  @moduledoc """
  A place for utility functions that might be used anywhere.
  """

  @doc """
  Generate a random string of a given length.
  """
  def get_random_string(length \\ 10) do
    :crypto.strong_rand_bytes(length)
    |> Base.encode64()
    |> binary_part(0, length)
  end
end
