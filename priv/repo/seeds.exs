# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Art.Repo.insert!(%Art.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
defmodule Seeder do
alias Art.Arts.Subject
alias Art.Repo
  def get_or_insert_subject(name) do
    Repo.insert!(
      %Subject{name: name},
      on_conflict: [set: [name: name]],
      conflict_target: :name
    )
  end
end


# Watts

# Spring 2020
%{
  "cost" => 99,
  #"start" => ~D[2011-05-20],
  #"end" => ~D[2010-04-17],
  "name" => "Head, Figure, Quicksketch",
  "subjects" => "Figure, Portrait, Drawing",
  "instructor" => "Jeff Watts",
  "website" => "Watts"
} |> Art.Arts.create_course()

%{
  "cost" => 99,
  #"start" => ~D[2011-05-20],
  #"end" => ~D[2010-04-17],
  "name" => "Bridgemans Anatomy",
  "subjects" => "Figure, Drawing",
  "instructor" => "Erik Gist",
  "website" => "Watts"
} |> Art.Arts.create_course()


# Class101

%{
  "cost" => 99,
  #"start" => ~D[2011-05-20],
  #"end" => ~D[2010-04-17],
  "name" => "Sketching Animals and Creatures with Pen and Ink",
  "subjects" => "Ink, Dynamic Sketching, Sketching",
  "instructor" => "Sophie Kim",
  "website" => "Class101"
} |> Art.Arts.create_course()
