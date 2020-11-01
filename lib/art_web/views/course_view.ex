defmodule ArtWeb.CourseView do
  use ArtWeb, :view

  def subject_input(form, field) do
    text_input(form, field, value: subject_value(form.source, form, field))
  end

  # if there is an error, pass the input params along
  defp subject_value(%Ecto.Changeset{valid?: false}, form, field) do
    form.params[to_string(field)]
  end

  defp subject_value(_source, form, field) do
    form
    |> input_value(field)
    |> subjects_to_text
  end

  defp subjects_to_text(subjects) do
    subjects
    |> Enum.map(fn t -> t.name end)
    |> Enum.join(", ")
  end

  def website_input(form, field) do
    text_input(form, field, value: website_value(form.source, form, field))
  end

  # if there is an error, pass the input params along
  defp website_value(%Ecto.Changeset{valid?: false}, form, field) do
    form.params[to_string(field)]
  end

  defp website_value(_source, form, field) do
    form
    |> input_value(field)
    |> website_to_text
  end

  defp website_to_text(website) do
    if website != nil do
    website.name
    else
      "N/A"
    end
  end
end
