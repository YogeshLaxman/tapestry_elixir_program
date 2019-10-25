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
  num_nodes = String.to_integer(num_nodes)
  req = String.to_integer(req)
  nodes = create_nodes (num_nodes)
  nodes_list = 1..num_nodes
  actual_nodes_list = Enum.to_list(nodes_list)
  TapestryDos.Routing.build_routing_tables(num_nodes)
  #TapestryDos.RoutingTables.build_routing_tables(num_nodes)
  IO.inspect(nodes)
end

defp create_nodes (num_nodes) do
  Enum.map(1..num_nodes, fn x -> 
    TapestryDos.DynamicNodeSupervisor.start_child_nodes(x)
  end)

    #TapestryDos.DynamicNodeSupervisor.start_child_node())
    #{:ok,pid} = TapestryDos.Node.start(4) |>IO.puts
end
end
