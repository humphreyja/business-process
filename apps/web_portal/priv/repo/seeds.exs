# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     WebPortal.Repo.insert!(%WebPortal.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

service = WebPortal.Repo.insert!(%WebPortal.APIService{name: "GitHub", description: "Simple Service to query GitHub for information", url: "https://api.github.com"})

WebPortal.Repo.insert!(%WebPortal.APIEndpoint{name: "User Information", description: "Gets a users information", auth: false, url: "https://api.github.com/users/{{user_name}}", headers: "", method: "GET", api_service_id: service.id})
WebPortal.Repo.insert!(%WebPortal.APIEndpoint{name: "User Repositories", description: "Gets a users repositories", auth: false, url: "https://api.github.com/users/{{user_name}}/repos", headers: "", method: "GET", api_service_id: service.id})
