defmodule TapestryDos.Node do
    
    use GenServer
    def start_link(initial_state) do
        GenServer.start_link(__MODULE__, initial_state)
    end

    def init(initial_state) do
        "Genserver started with the state #{initial_state}" |>IO.puts
        {:ok,initial_state}
    end

end