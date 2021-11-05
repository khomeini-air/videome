defmodule Videome.VideoGenerator.FfmpegUtilTest do
  use ExUnit.Case
  alias Videome.VideoGenerator.FfmpegUtil

  test "gen slideshow video" do
    assert FfmpegUtil.gen("abc","img%03d.png") == {:ok, "abc/abc.mp4"}
  end

end
