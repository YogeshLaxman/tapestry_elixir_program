defmodule TapestryDos.Main do
    def run(argv) do
      argv
      |> extract_numnodes_requests
      |> start_main
    end
    
    def extract_numnodes_requests(args) do
      num_request = OptionParser.parse(args,aliases: [g: :guide] ,switches: [guide: :boolean])
      case num_request do
        {[guide: true],_,_} -> :guide
        {_, [num_nodes,req],_} -> {num_nodes,req}
        _ -> :guide
      end
    end
    
    def start_main(:guide) do
      IO.puts("""
               Syntax Error. Please run the program using 
               mix run project3.exs <Number of nodes> <Number of requpests>
               """)
    System.halt(0)
    end
    
    def start_main({num_nodes,req}) do
     # nodes_number = num_node
      num_nodes = String.to_integer(num_nodes)
      req = String.to_integer(req)
      IO.puts("Waiting for completion of Tapestry Protocol..");
      #Building a route map of all nodes and their routing tables
      routing_map = Enum.map(1..num_nodes, fn n -> {"rt_#{n}", TapestryDos.ProcessRouting.make_routing_table(n, 1..num_nodes)} end)
      routing_map = Enum.into(routing_map, %{})
      #Building a pid map of all nodes and their processId
      nodes_pid_map = Enum.map(1..num_nodes, fn n -> { "pid_#{n}",TapestryDos.DynamicNodeSupervisor.start_child_nodes([n,routing_map["rt_#{n}"],num_nodes, req])} end)
      nodes_pid_map = Enum.into(nodes_pid_map, %{})
   
      # Creating dynamic nodes and their maps
      add_nodes =   0.1*num_nodes |> round()
      add_rt_map = Enum.map(num_nodes+1..num_nodes + add_nodes, fn n -> {"rt_#{n}", TapestryDos.ProcessRouting.make_routing_table(n, 1..n)} end)
      add_rt_map = Enum.into(add_rt_map, %{})
      add_nodes_pid_map = Enum.map(num_nodes+1..num_nodes + add_nodes, fn n -> { "pid_#{n}",TapestryDos.DynamicNodeSupervisor.start_child_nodes([n,routing_map["rt_#{n}"],1..num_nodes + add_nodes, req])} end)
      add_nodes_pid_map = Enum.into(add_nodes_pid_map, %{})
        
      #Update routing and pid maps
      updated_rt_map = Map.merge(routing_map, add_rt_map)
      updated_nodes_pid_map = Map.merge(nodes_pid_map, add_nodes_pid_map)
      #IO.inspect(updated_rt_map)
     
      #Updating the routing maps
        
      
      updated_rt_map = Enum.map(1..num_nodes + add_nodes, fn n -> {"rt_#{n}", TapestryDos.ProcessRouting.update_routing_table(n, 1..n)} end)
      updated_rt_map = Enum.into(updated_rt_map, %{})
      hash_to_pid = Enum.into(Enum.map(1..num_nodes + add_nodes, fn n -> {TapestryDos.ProcessRouting.hash_of(n), Map.get(updated_nodes_pid_map, "pid_#{n}")} end), %{})

        TapestryDos.DynamicNodeSupervisor.start_state(num_nodes + add_nodes, req)

      all_guids = Enum.map(1..num_nodes + add_nodes, fn n -> TapestryDos.ProcessRouting.hash_of(n) end)
      Enum.each(1..num_nodes + add_nodes, fn n -> GenServer.cast(Map.get(updated_nodes_pid_map, "pid_#{n}"), {:update_routing_table, Map.get(updated_rt_map, "rt_#{n}"), hash_to_pid, all_guids}) end)
      Enum.each(1..num_nodes + add_nodes, fn n -> GenServer.cast(Map.get(updated_nodes_pid_map, "pid_#{n}"), {:kickoff}) end)
      
      wait_for_completion()
      IO.puts("Max number of hops:")
      IO.puts TapestryDos.State.max()
      IO.puts("Task ended")
    end
    
    def wait_for_completion() do
    
        if TapestryDos.State.end_of_task() do
           nil
        else
            :timer.sleep(100)
            wait_for_completion()
        end
    end



    def make_routing_tables (nodes_list) do
      for node_pid <- nodes_list do
        TapestryDos.Node.make_routing_table(node_pid,nodes_list -- [node])
      end
    end
        
end
    