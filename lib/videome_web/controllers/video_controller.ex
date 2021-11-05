defmodule VideomeWeb.VideoController do
  use VideomeWeb, :controller
  alias Videome.VideoGenerator

  def create(conn, %{"upload" => params}) do
    %{"photos" => upload_plugs} = params

    case gen_video (upload_plugs) do
      {:ok, video_file} -> send_download_file(conn, video_file)
      {:error, msg} -> display_error(conn, msg)
    end
  end

  defp gen_video(upload_plugs) do
    VideoGenerator.generate(get_photo_path_with_ext(upload_plugs, []))
  end

  defp send_download_file(conn, video_file) do
    conn
    |> put_flash(:info, "Your video is successfully created")
    |> send_download({:file, video_file})
  end

  defp display_error(conn, msg) do
    conn
    |> put_flash(:error, msg)
    |> redirect(to: "/")
  end

  defp get_photo_path_with_ext([], acc) do
    acc
  end

  defp get_photo_path_with_ext([head | tail], acc) do
    path = Map.get(head, :path)
    content_type = Map.get(head, :content_type)

    if (!File.exists?(path)), do: get_photo_path_with_ext(tail, acc)

    new_name = path <> get_extension(content_type)

    if (File.rename(path, new_name)),
    do: get_photo_path_with_ext(tail, acc ++ [new_name]),
    else: get_photo_path_with_ext(tail, acc)
  end

  defp get_extension(content_type) do
    "." <> hd(MIME.extensions(content_type))
  end
end
