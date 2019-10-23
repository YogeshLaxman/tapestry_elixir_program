defmodule TapestryDos.Node do
    
    use GenServer

    #-------------------------API-----------------------------------#

    def start_link([x]) do
        GenServer.start_link(__MODULE__, [x])
    end


    #------------------Callback functions--------------------------#

    def init([x]) do

        routing_table = create(16, 40)
        IO.inspect(routing_table)
        # IO.inspect(routing_table)
        # "Node started with number #{x}" |>IO.puts
        # Enum.map(1..num_nodes, fn x -> 
        #     TapestryDos.DynamicNodeSupervisor.start_child_nodes(x)
        #   end)

        hash_id = hash_of(x) 
        IO.inspect(hash_id)
        {:ok,{routing_table}}
    end

    def create(w, h) do
        List.duplicate(0, w)
          |> List.duplicate(h)
    end

    def hash_of(number) do
       hex_val = :crypto.hash(:sha, number |> Integer.to_string ) |> Base.encode16
       hex_val
    end
end