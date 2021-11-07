defmodule Videome.VideoGeneratorTest do
  use ExUnit.Case
  alias Videome.VideoGenerator

  test "gen slideshow" do
    # This test requires the availability of files in img_paths
    img_paths = ["priv/file_for_video_generator/a.png", "priv/file_for_video_generator/b.png"]
    {:ok, output_file} = VideoGenerator.generate(img_paths)

    assert output_file =~ "slideshow.mp4"
  end
end
