defmodule Dispatcher do
  use Plug.Router

  def start(_argv) do
    port = 80
    IO.puts "Starting Plug with Cowboy on port #{port}"
    Plug.Adapters.Cowboy.http __MODULE__, [], port: port
    :timer.sleep(:infinity)
  end

  plug Plug.Logger
  plug :match
  plug :dispatch

  # In order to forward the 'themes' resource to the
  # resource service, use the following forward rule.
  #
  # docker-compose stop; docker-compose rm; docker-compose up
  # after altering this file.
  #
  # match "/themes/*path" do
  #   Proxy.forward conn, path, "http://resource/themes/"
  # end

  post "/meetings/*path" do
    Proxy.forward conn, path, "http://export/meetings/"
  end

  get "/public-export-jobs/*path" do
    Proxy.forward conn, path, "http://export/public-export-jobs/"
  end

  get "/publications/*path" do
    Proxy.forward conn, path, "http://publication-producer/files/"
  end

  get "/files/*path" do
    Proxy.forward conn, path, "http://file/files/"
  end

  get "/kaleidos-files/*path" do
    Proxy.forward conn, path, "http://kaleidos-public-file/files/"
  end

  match _ do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end


end
