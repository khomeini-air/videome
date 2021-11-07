defmodule Videome.VideoGenerator.FfmpegUtilTest do
  use ExUnit.Case
  alias Videome.VideoGenerator.FfmpegUtil

  test "gen slideshow video" do
    {:ok, output_file} = FfmpegUtil.gen("priv/abc/img%03d.png")
    assert output_file =~ "slideshow.mp4"
  end
end
