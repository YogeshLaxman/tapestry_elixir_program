defmodule TapestryDos.Node do
    
    use GenServer
    def start_link([x]) do
        GenServer.start_link(__MODULE__, [x])
    end

    def init([x]) do
        # state = Map.merge(arg, %{
        #     ,
        #     predecessor: nil,
        #     successor: nil,
        #     finger: finger,
        #     failNode: failNode,
        #     total_hops: 0,
        #     msg_delivered: 0,
        #     alive: not failNode
        #   })
        "Node started with number #{x}" |>IO.puts

        hash_id = hash_of(x) 
        IO.inspect(hash_id)
        {:ok,%{}}
    end

    def hash_of(number) do
       hex_val = :crypto.hash(:sha, number |> Integer.to_string ) |> Base.encode16
       hex_val
    end
end