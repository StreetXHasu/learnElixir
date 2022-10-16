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
        dEnd: ~N[2022-10-15 11:37:00],
        dStart: ~N[2022-10-15 11:37:00],
        description: "some description",
        isActive: true,
        name: "some name"
      })
      |> EventPlanning.Accounts.create_event()

    event
  end
end
