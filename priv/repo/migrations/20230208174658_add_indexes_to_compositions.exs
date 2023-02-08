defmodule MusicDB.Repo.Migrations.AddIndexesToCompositions do
  use Ecto.Migration
  def change do
    create index("compositions", [:title, :year])
  end
end
