# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SSO.Repo.insert!(%SSO.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

SSO.Repo.delete_all SSO.User
SSO.Repo.delete_all SSO.Client

SSO.User.changeset(%SSO.User{}, %{name: "User", email: "user@test.com", password: "password123", password_confirmation: "password123"})
|> SSO.Repo.insert!
|> Coherence.ControllerHelpers.confirm!

SSO.User.admin_changeset(%SSO.User{}, %{admin: true, name: "Admin", email: "admin@test.com", password: "password123", password_confirmation: "password123"})
|> SSO.Repo.insert!
|> Coherence.ControllerHelpers.confirm!

SSO.Client.changeset(%SSO.Client{}, %{name: "Blackboard App", client_key: "blackboard", home_page: "http://localhost:3000", sign_in_redirect_url: "http://localhost:3000/authorize/new", sign_out_redirect_url: "http://localhost:3000/authorize/delete", secret: "blackboard_secret"})
|> SSO.Repo.insert!
