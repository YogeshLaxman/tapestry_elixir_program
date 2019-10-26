defmodule TapestryDos.Node do
    
    use GenServer

    #-------------------------API-----------------------------------#

    def start_link([x]) do
        GenServer.start_link(__MODULE__, [x])
    end

    # def make_routing_table(pid, node_num_list ) do
    #     Genserver.cast(pid, {:make_routing_table, self_node_num, node_num_list })
    # end
    
    def print_value(pid, node_num_list ) do
        Genserver.cast(pid, {:print})
    end

    #------------------Callback functions--------------------------#

    def init([x]) do
        [node_number|rt] = x
        # routing_table = create(16, 40)
        # IO.inspect(routing_table)
        # "Node started with number #{x}" |>IO.puts
        # Enum.map(1..num_nodes, fn x -> 
        #     TapestryDos.DynamicNodeSupervisor.start_child_nodes(x)
        #   end)

        # hash_id = hash_of(x) 
        # IO.inspect(hash_id)

        # routing_table = TapestryDos.ProcessRouting.make_routing_table(x)

        # IO.inspect(routing_table)
        # IO.puts("Routing table of Node#{x} ended")

        #routing_table = TapestryDos.get_rt_value("rt_#{node_number}")
        {:ok,{rt}}
    end
    def handle_cast({:push, element}, state) do
        {:noreply, [element | state]}
      end

    def handle_cast({:make_routing_table, self_node_num, node_num_list },{routing_table}) do
        TapestryDos.ProcessRouting.make_routing_table(self_node_num, node_num_list )
        {:noreply, {routing_table}}
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