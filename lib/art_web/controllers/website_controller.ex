defmodule ArtWeb.WebsiteController do
  use ArtWeb, :controller

  alias Art.Arts
  alias Art.Arts.Website

  def index(conn, _params) do
    websites = Arts.list_websites()
    render(conn, "index.html", websites: websites)
  end

  def new(conn, _params) do
    changeset = Arts.change_website(%Website{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"website" => website_params}) do
    case Arts.create_website(website_params) do
      {:ok, website} ->
        conn
        |> put_flash(:info, "Website created successfully.")
        |> redirect(to: Routes.website_path(conn, :show, website))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    website = Arts.get_website!(id)
    render(conn, "show.html", website: website)
  end

  def edit(conn, %{"id" => id}) do
    website = Arts.get_website!(id)
    changeset = Arts.change_website(website)
    render(conn, "edit.html", website: website, changeset: changeset)
  end

  def update(conn, %{"id" => id, "website" => website_params}) do
    website = Arts.get_website!(id)

    case Arts.update_website(website, website_params) do
      {:ok, website} ->
        conn
        |> put_flash(:info, "Website updated successfully.")
        |> redirect(to: Routes.website_path(conn, :show, website))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", website: website, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    website = Arts.get_website!(id)
    {:ok, _website} = Arts.delete_website(website)

    conn
    |> put_flash(:info, "Website deleted successfully.")
    |> redirect(to: Routes.website_path(conn, :index))
  end
end
