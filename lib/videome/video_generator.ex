defmodule Videome.VideoGenerator do
  alias Videome.VideoGenerator.FfmpegUtil

  def generate(paths) do
    uuid = UUID.uuid1()
    dir_path = Path.join("priv/video_gen", uuid)

    File.mkdir(dir_path)

    renamed_photos = move_photo(paths, [], dir_path)

    gen_video(dir_path, "img%03d#{get_extension(hd(renamed_photos))}")
  end

  defp gen_video(dir_path, photo_paths) do
    FfmpegUtil.gen(dir_path, photo_paths)
  end

  defp move_photo([], acc, _dir_path) do
    acc
  end

  defp move_photo([head | tail], acc, dir_path) do
    if !File.exists?(head), do: move_photo(tail, acc, dir_path)

    ext = Path.extname(head)
    new_path = Path.join(dir_path, "img00#{length(acc)+1}#{ext}")

    if File.rename(head, new_path),
      do: move_photo(tail, acc ++ [new_path], dir_path),
      else: move_photo(tail, acc, dir_path)
  end

  defp get_extension(path) do
     Path.extname(path)
  end
end
