defmodule Videome.VideoGeneratorTest do
  use ExUnit.Case
  alias Videome.VideoGenerator

  test "gen slideshow" do
    path = ["file_for_video_generator/a.png","file_for_video_generator/b.png"]
    VideoGenerator.generate(path) =~ {:ok, ".mp4"}
  end
end
