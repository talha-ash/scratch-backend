defmodule ScratchAppWeb.Resolvers.Helpers do
  def resolve_images(parent, _args, %{context: %{current_user: _current_user}}) do
    if(parent.id && Map.has_key?(parent, :image) && Map.has_key?(parent.image, :file_name)) do
      file_name = parent.image.file_name
      {:ok, ScratchApp.MediaResourceManager.url({file_name, %{scope_id: parent.id}})}
    else
      {:ok, ""}
    end
  end

  def resolve_ingredient_images(parent, _args, %{context: %{current_user: _current_user}}) do
    if(
      parent.id && Map.has_key?(parent, :image_url) && Map.has_key?(parent.image_url, :file_name)
    ) do
      file_name = parent.image_url.file_name
      path = %{path: "uploads/ingredient"}
      {:ok, ScratchApp.MediaResourceManager.url({file_name, %{scope_id: path}})}
    else
      {:ok, ""}
    end
  end

  def resolve_videos(parent, _args, %{context: %{current_user: _current_user}}) do
    if(parent.id && Map.has_key?(parent, :video) && Map.has_key?(parent.video, :file_name)) do
      file_name = parent.video.file_name
      {:ok, ScratchApp.MediaResourceManager.url({file_name, %{scope_id: parent.id}})}
    else
      {:ok, ""}
    end
  end
end
