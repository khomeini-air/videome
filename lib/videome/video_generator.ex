defmodule Videome.VideoGenerator do
  alias Videome.VideoGenerator.FfmpegUtil

  @doc """
  Generate the video contains the images specified in paths.
  Uploaded file will be removed to a unique folder created inside priv/video_gen/ allowing concurrent request to be processed.

  Returns `{:ok, output_file}` on success, or `{:error, err_message}` on error.
  """
  def generate(paths) do
    # This uuid will be used as unique folder to store user uploaded images for this specific request to handle concurrency.
    uuid = UUID.uuid1()
    video_gen_folder = Path.join("priv","video_gen")
    dir_path = Path.join(video_gen_folder, uuid)

    File.mkdir(dir_path)

    # Move uploaded photos from temp folder to its specific folder.
    renamed_photos = move_photo(paths, [], dir_path)

    # Invoke the ffmpex lib
    gen_video(Path.join(dir_path, "img%03d#{get_extension(hd(renamed_photos))}"))
  end

  defp gen_video(image_paths) do
    FfmpegUtil.gen(image_paths)
  end

  defp move_photo([], acc, _dir_path) do
    acc
  end

  defp move_photo([head | tail], acc, dir_path) do
    if !File.exists?(head), do: move_photo(tail, acc, dir_path)

    ext = Path.extname(head)
    new_path = Path.join(dir_path, "img00#{length(acc) + 1}#{ext}")

    if File.rename(head, new_path),
      do: move_photo(tail, acc ++ [new_path], dir_path),
      else: move_photo(tail, acc, dir_path)
  end

  defp get_extension(path) do
    Path.extname(path)
  end
end
