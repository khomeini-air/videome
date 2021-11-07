defmodule Videome.VideoGenerator.FfmpegUtil do
  import FFmpex
  use FFmpex.Options
  require Logger

  @doc """
  generate the video using ffmpex library

  Returns `{:ok, output_file}` on success, or `{:error, err_message}` on error.
  """
  def gen(img_path) do
    dir_path = Path.dirname(img_path)
    output_file = Path.join(dir_path, "slideshow.mp4")

    command =
      FFmpex.new_command()
      |> add_global_option(option_y())
      |> add_input_file(img_path)
      |> add_file_option(option_framerate("1/2"))
      |> add_output_file(output_file)
      |> add_stream_specifier(stream_type: :video)
      |> add_stream_option(option_r("30"))

    case execute(command) do
      :ok ->
        {:ok, output_file}

      {:error, {collectable, _exit_code}} ->
        Logger.error("create video failed: #{collectable}")
        {:error, "Unable to create your video - Please ensure to upload uncorrupted images only"}
    end
  end
end
