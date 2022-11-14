defmodule EventPlanningWeb.EventChannel do
  use EventPlanningWeb, :channel

  alias EventPlanning.Accounts
  alias EventPlanning.Accounts.Event

  intercept ["delete"]
  @impl true

  # def join("room:lobby", _message, socket) do
  #   {:ok, socket}
  # end

  # def join("room:" <> _private_room_id, _params, _socket) do
  #   {:error, %{reason: "unauthorized"}}
  # end

  def join("event:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Delete Events
  @impl true
  def handle_in("delete", %{"data" => id}, socket) do
    broadcast(socket, "delete", %{id: id})
    {:noreply, socket}
  end

  @impl true
  def handle_out("delete", msg, socket) do
    event = Accounts.get_event!(msg.id)
    {:ok, _event} = Accounts.delete_event(event)
    push(socket, "delete", msg)
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (event:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(%{"params" => %{"token" => token}}) do
    token == "true"
  end
end
