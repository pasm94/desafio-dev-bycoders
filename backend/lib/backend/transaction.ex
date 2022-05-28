defmodule Backend.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:type, :date, :value, :cpf, :card, :hour, :store_owner, :store]
  @derive {Jason.Encoder, only: [:id] ++ @fields}

  schema "transactions" do
    field :card, :string
    field :cpf, :string
    field :date, :date
    field :hour, :time
    field :store, :string
    field :store_owner, :string
    field :type, :integer
    field :value, Money.Ecto.Amount.Type
  end

  def changeset(struct \\ %__MODULE__{}, attrs) do
    struct
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
