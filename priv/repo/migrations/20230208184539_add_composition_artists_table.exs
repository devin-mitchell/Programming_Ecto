defmodule MusicDB.Repo.Migrations.AddCompositionArtistsTable do
  use Ecto.Migration
  import Ecto.Query
  alias MusicDB.Repo

  def up do
    create table("compositions_artists") do
      add :composittion_id, reference("compossitions"), null: false
      add :artist_id, reference("artists"), null, false
      add :role, :string, null: false
    end

    create index("compositions_artists", :compostition_id)
    create index("compositions_artists", :artist_id)

    flush()

    from(c in "compossitions", select: [:id, :artist_id])
    |> Repo.all()
    |> Enum.each(fn row ->
      Repo.insert_all("compositions_artists", [
        [composition_id: row.id, artist_id: row.artist_id, role: "composer"]
      ])
    end)

    alter table("compositions") do
      remove :artist_id
    end
  end

  def down do
    alter table("compositions") do
      add :artist_id, references("artists")
    end

    flush()

    from(ca in "compositions_artists", where: ca.role == "composer", select: [:composition_id, :artist_id])
      |> Repo.all()
      |> Enum.each(fn row ->
        Repo.update_all(
          from(c in "compositions", where: c.id == row.composition_id),
          set: [artist_id: row.artist_id]
        )
      end)

    drop table("compositions_artists")
  end
end
