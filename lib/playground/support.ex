defmodule Playground.Support do
  use Ash.Api,
    extensions: [AshAdmin.Api]

  alias Playground.Support.Representative
  alias Playground.Support.Ticket

  admin do
    show? true
  end

  resources do
    registry Playground.Support.Registry
  end

  def all_open_tickets do
    Ticket.filter_open!(load: :representative)
  end

  def all_closed_tickets do
    Ticket.filter_closed!(load: :representative)
  end

  def filter_tickets_by_status(offset, status \\ :all) do
    Ticket.filter!(status, page: [offset: offset, count: true], load: :representative)
  end

  def all_active_representatives do
    Representative.filter_active!(load: [:total_tickets, :open_tickets, :percent_open])
  end
end
