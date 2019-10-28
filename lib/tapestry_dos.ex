defmodule TapestryDos do
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
  
  #make_routing_tables(nodes)

  routing_map = Enum.map(1..num_nodes, fn n -> {"rt_#{n}", TapestryDos.ProcessRouting.make_routing_table(n, 1..num_nodes)} end)
  routing_map = Enum.into(routing_map, %{})
  nodes_pid_map = Enum.map(1..num_nodes, fn n -> { "pid_#{n}",TapestryDos.DynamicNodeSupervisor.start_child_nodes([n,routing_map["rt_#{n}"],num_nodes])} end)
  nodes_pid_map = Enum.into(nodes_pid_map, %{})
  IO.inspect(nodes_pid_map)
  # IO.inspect(routing_map)
  # Creating dynamic nodes
  add_nodes =   0.1*num_nodes |> round()
  add_rt_map = Enum.map(num_nodes+1..num_nodes + add_nodes, fn n -> {"rt_#{n}", TapestryDos.ProcessRouting.make_routing_table(n, 1..n)} end)
  add_rt_map = Enum.into(add_rt_map, %{})
  add_nodes_pid_map = Enum.map(num_nodes+1..num_nodes + add_nodes, fn n -> { "pid_#{n}",TapestryDos.DynamicNodeSupervisor.start_child_nodes([n,routing_map["rt_#{n}"],1..num_nodes + add_nodes])} end)
  add_nodes_pid_map = Enum.into(add_nodes_pid_map, %{})
  IO.inspect(add_rt_map)
  IO.inspect(add_nodes_pid_map)
  updated_rt_map = Map.merge(routing_map, add_rt_map)
  updated_nodes_pid_map = Map.merge(nodes_pid_map, add_nodes_pid_map)
  IO.inspect(updated_nodes_pid_map)
  add_rt_map = Enum.map(1..num_nodes + add_nodes, fn n -> {"rt_#{n}", TapestryDos.ProcessRouting.make_routing_table(n, 1..n)} end)
  add_rt_map = Enum.into(add_rt_map, %{})
  IO.inspect(add_rt_map)
  # Update previous node values
  # look for possible candidates
  # IO.inspect(routing_map["rt_#{1}"]) 
  # nodes = create_nodes (num_nodes)
  # IO.inspect(routing_map)
  # nodes_list = 1..num_nodes
  # actual_nodes_list = Enum.to_list(nodes_list)
  # create_all_routing_table(actual_nodes_list)
  # TapestryDos.Routing.build_routing_tables(num_nodes)
  # #TapestryDos.RoutingTables.build_routing_tables(num_nodes)
  # nodes = create_nodes (num_nodes)
  # IO.inspect(nodes)n
  # IO.inspect(routing_map) 
  # IO.inspect(nodes_pid_map)
  # IO.inspect(nodes_pid_map["pid_#{98}"])
end

defp create_dynamic_nodes(new_nodes_number,num_nodes,nodes_pid_map,routing_map) do
  

   Enum.map(num_nodes+1..num_nodes + new_nodes_number, fn n -> 
    routing_map = Map.put(routing_map, "rt_#{n}" , TapestryDos.ProcessRouting.make_routing_table(n, 1..num_nodes) )
   end)
   Enum.map(num_nodes+1..num_nodes + new_nodes_number, fn n -> 
    nodes_pid_map = Map.put(nodes_pid_map, "pid_#{n}" , TapestryDos.ProcessRouting.make_routing_table(n, 1..num_nodes) )
   end)
   IO.inspect(routing_map["rt_#{98}"])
  # routing_map = Enum.into(routing_map, %{})
  # nodes_pid_map = Enum.map(num_nodes+1..num_nodes + new_nodes_number, fn n -> { "pid_#{n}",TapestryDos.DynamicNodeSupervisor.start_child_nodes([n,routing_map["rt_#{n}"]])} end)
  # nodes_pid_map = Enum.into(nodes_pid_map, %{})
  # IO.inspect(routing_map)  
  # IO.inspect(nodes_pid_map)
end

defp create_nodes (num_nodes) do
  Enum.map(1..num_nodes, fn x -> 
    TapestryDos.DynamicNodeSupervisor.start_child_nodes(x)
  end)

    #TapestryDos.DynamicNodeSupervisor.start_child_node())
    #{:ok,pid} = TapestryDos.Node.start(4) |>IO.puts
end

def make_routing_tables (nodes_list) do
  for node_pid <- nodes_list do
    TapestryDos.Node.make_routing_table(node_pid,nodes_list -- [node])
  end
end

# def get_rt_value(string) do
#   routing_map[string]
# end

def create_all_routing_table (nodes_list) do
  for node <- nodes_list do
    TapestryDos.Node.make_routing_table(node,nodes_list -- [node])
  end
end
end
