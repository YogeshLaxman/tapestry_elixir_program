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
           mix run project3.exs <Number of nodes> <Number of requests>
           """)
System.halt(0)
end

def start_main({num_nodes,req}) do
  num_nodes = String.to_integer(num_nodes)
  req = String.to_integer(req)
  nodes = create_nodes (num_nodes)
end

defp create_nodes (num_nodes) do
  Enum.map(1..num_node, fn _->
    TapestryDos.DynamicNodeSupervisor.start_child_node())
end
end
