# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Mysulpak.Repo.insert!(%Mysulpak.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Mysulpak.Repo, as: R

data = [
  %{name: "Shrek crocs", desc: "somebody once", picture: "https://avatars.mds.yandex.net/i?id=ce6d60c1db222be4b3cf57d98c8610b73d25a6f5-9181740-images-thumbs&n=13"},
  %{name: "Mr. Beast T-Shirt", desc: "mr BEEAASST, mr-mr-mr BEAST"}
]

R.insert!(Mysulpak.Store.Item, data)
