defmodule MusicDB.Repo.Migrations.AddCompositionsTable do
  use Ecto.Migration

  def change do
    create table("compositions") do
      add :title, :string, null: false
      add :year, :integer, null: false
      add :artist_id, references("artists"), null: false

      timestamps()
    end
  end
end
