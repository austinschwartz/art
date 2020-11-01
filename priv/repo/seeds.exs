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

# Fall 2020
%{
  "cost" => 99,
  #"start" => ~D[2011-05-20],
  #"end" => ~D[2010-04-17],
  "name" => "20m Head Lay-ins",
  "website" => "Watts",
  "subjects" => "Portrait, Drawing",
  "instructor" => "Ben M. Young"
} |> Art.Arts.create_course()

%{
  "cost" => 99,
  #"start" => ~D[2011-05-20],
  #"end" => ~D[2010-04-17],
  "name" => "Perspective Fundamentals",
  "website" => "Watts",
  "subjects" => "Perspective, Drawing",
  "instructor" => "Brian Knox"
} |> Art.Arts.create_course()

%{
  "cost" => 99,
  #"start" => ~D[2011-05-20],
  #"end" => ~D[2010-04-17],
  "name" => "Anatomy Intensives: Torso",
  "website" => "Watts",
  "subjects" => "Anatomy, Drawing, Figure",
  "instructor" => "Erik M. Gist"
} |> Art.Arts.create_course()

%{
  "cost" => 99,
  #"start" => ~D[2011-05-20],
  #"end" => ~D[2010-04-17],
  "name" => "Sketchbooking Techniques & Subjects",
  "website" => "Watts",
  "subjects" => "Sketching",
  "instructor" => "Jeffrey R. Watts"
} |> Art.Arts.create_course()

%{
  "cost" => 99,
  #"start" => ~D[2011-05-20],
  #"end" => ~D[2010-04-17],
  "name" => "20 Minute Figure Lay-ins",
  "website" => "Watts",
  "subjects" => "Figure, Drawing",
  "instructor" => "Erik M. Gist"
} |> Art.Arts.create_course()









# Spring 2020
%{
  "cost" => 99,
  #"start" => ~D[2011-05-20],
  #"end" => ~D[2010-04-17],
  "name" => "Bridgemans Anatomy",
  "subjects" => "Figure, Drawing",
  "instructor" => "Erik M. Gist",
  "website" => "Watts"
} |> Art.Arts.create_course()


# Class101

%{
  "cost" => 135,
  #"start" => ~D[2011-05-20],
  #"end" => ~D[2010-04-17],
  "name" => "Sketching Animals and Creatures with Pen and Ink",
  "subjects" => "Ink, Dynamic Sketching, Sketching",
  "instructor" => "Sophie Kim",
  "website" => "Class101"
} |> Art.Arts.create_course()
