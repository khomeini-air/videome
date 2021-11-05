defmodule Videome.VideoGenerator.FfmpegUtil do
  import FFmpex
  use FFmpex.Options

  def gen(dir_path, img_path) do
    output_file = Path.join(dir_path, "slideshow.mp4")

    command =
      FFmpex.new_command()
      |> add_global_option(option_y())
      |> add_input_file(Path.join(dir_path, img_path))
      |> add_file_option(option_framerate("1/3"))
      |> add_output_file(output_file)
      |> add_stream_specifier(stream_type: :video)
      |> add_stream_option(option_b("64k"))
      |> add_stream_option(option_r("30"))
      |> add_stream_option(option_pix_fmt("yuv420p"))
      |> add_file_option(option_maxrate("128k"))
      |> add_file_option(option_bufsize("64k"))

    case execute(command) do
      :ok -> {:ok, output_file}
      {:error, {_, _}} -> {:error, "Unable to create your video - Please ensure to upload uncorrupted images only"}
    end
  end
end
