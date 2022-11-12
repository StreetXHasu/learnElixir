defmodule EventPlanning.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EventPlanning.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        age: 42,
        name: "some name"
      })
      |> EventPlanning.Accounts.create_user()

    user
  end

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        date_end: ~N[2022-10-15 11:37:00],
        date_start: ~N[2022-10-15 11:37:00],
        repeat: 0,
        description: "some description",
        name: "some name"
      })
      |> EventPlanning.Accounts.create_event()

    event
  end
end
