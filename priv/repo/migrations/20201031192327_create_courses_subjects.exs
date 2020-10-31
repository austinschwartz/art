defmodule Art.Repo.Migrations.CreateCoursesSubjects do
  use Ecto.Migration

  def change do
    create table(:courses_subjects, primary_key: false) do
      add :course_id, references(:courses, on_delete: :nothing), primary_key: true
      add :subject_id, references(:subjects, on_delete: :nothing), primary_key: true
    end

    create index(:courses_subjects, [:course_id])
    create index(:courses_subjects, [:subject_id])
  end
end
