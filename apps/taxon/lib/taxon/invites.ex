defmodule Taxon.Invites do
  @moduledoc """
  The Invites context.
  """

  import Ecto.Query, warn: false
  alias Taxon.Repo

  alias Taxon.Invites.InviteCode

  @doc """
  Returns the list of invite_codes.

  ## Examples

      iex> list_invite_codes()
      [%InviteCode{}, ...]

  """
  def list_invite_codes do
    Repo.all(InviteCode)
  end

  @doc """
  Gets a single invite_code.

  Raises `Ecto.NoResultsError` if the Invite code does not exist.

  ## Examples

      iex> get_invite_code!(123)
      %InviteCode{}

      iex> get_invite_code!(456)
      ** (Ecto.NoResultsError)

  """
  def get_invite_code!(id), do: Repo.get!(InviteCode, id)

  def get_invite_code_by_code(code), do: Repo.get_by(InviteCode, code: code)

  @doc """
  Creates a invite_code.

  ## Examples

      iex> create_invite_code(%{field: value})
      {:ok, %InviteCode{}}

      iex> create_invite_code(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_invite_code(attrs \\ %{}) do
    %InviteCode{}
    |> InviteCode.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a invite_code.

  ## Examples

      iex> update_invite_code(invite_code, %{field: new_value})
      {:ok, %InviteCode{}}

      iex> update_invite_code(invite_code, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_invite_code(%InviteCode{} = invite_code, attrs) do
    invite_code
    |> InviteCode.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a invite_code.

  ## Examples

      iex> delete_invite_code(invite_code)
      {:ok, %InviteCode{}}

      iex> delete_invite_code(invite_code)
      {:error, %Ecto.Changeset{}}

  """
  def delete_invite_code(%InviteCode{} = invite_code) do
    Repo.delete(invite_code)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking invite_code changes.

  ## Examples

      iex> change_invite_code(invite_code)
      %Ecto.Changeset{data: %InviteCode{}}

  """
  def change_invite_code(%InviteCode{} = invite_code, attrs \\ %{}) do
    InviteCode.changeset(invite_code, attrs)
  end
end
