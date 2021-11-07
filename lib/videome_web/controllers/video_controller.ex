defmodule VideomeWeb.VideoController do
  use VideomeWeb, :controller
  alias Videome.VideoGenerator

  @doc """
  Start processing the images uploaded by user and return a slideshow video to download
  """
  def create(conn, param) do
    upload_param = Map.get(param, "upload")

    # Validate param.
    validate_param(conn, upload_param)

    # Get photo paths from upload plug and prefix them with extension.
    photo_paths = get_photo_path_with_ext(Map.get(upload_param, "photos"), [])

    # Start procession all images and create the slideshow
    case gen_video(photo_paths) do
      {:ok, video_file} -> send_download_file(conn, video_file)
      {:error, msg} -> display_error(conn, msg)
    end
  end

  defp validate_param(conn, upload_param) do
    if !upload_param,
      do: conn |> put_flash(:error, "Please select your images") |> redirect(to: "/")
  end

  defp gen_video(photo_paths) do
    VideoGenerator.generate(photo_paths)
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

    if !File.exists?(path), do: get_photo_path_with_ext(tail, acc)

    new_name = path <> get_extension(content_type)

    if File.rename(path, new_name),
      do: get_photo_path_with_ext(tail, acc ++ [new_name]),
      else: get_photo_path_with_ext(tail, acc)
  end

  defp get_extension(content_type) do
    ".#{hd(MIME.extensions(content_type))}"
  end
end
