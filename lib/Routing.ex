defmodule TapestryDos.Routing do
    def build_routing_tables (num_nodes) do
        #Take SHA of i compare it with every j and arrange accordingly
        nodes_list = 1..num_nodes
        actual_nodes_list = Enum.to_list(nodes_list)
        actual_sha_list = Enum.map(1..num_nodes, fn n -> 
           hash_of(n) 
        end)
        IO.inspect actual_sha_list
        # IO.puts("actual_sha_list: #{inspect actual_sha_list}")
        #String.at(actual_sha_list, x - 1)
        # Enum.map(1..num_nodes, fn i -> 
        #     compare_sha_of(i,num_nodes) 
        # end)
        Enum.map(1..num_nodes, fn i -> 
                 find_routing_table_of(i,actual_sha_list) 
        end)
        
    end

    def find_routing_table_of(node,actual_sha_list) do
        sha_of_node = hash_of(node)
        # Enum.map(1..640, fn block -> 
        #     find_block_value(block, sha_of_node, actual_sha_list)
        # end)
        IO.inspect("Node : #{node} Actual: #{actual_sha_list}")
    end

    # def find_block_value (block,sha_of_node,actual_sha_list) do
    #     IO.inspect("Block: #{block} Node SHA: #{sha_of_node} Actual: #{actual_sha_list}")
    # end

    # def compare_sha_of(node,num_nodes) do

    #     Enum.map(1..num_nodes, fn j -> 
    #         with_sha_of(j,node) 
    #     end)
    # end

    # def with_sha_of(j,node) do
    #     IO.puts("Comparing j #{j} and node #{node}")
    #     sha_node = hash_of(node)
    #     sha_j = hash_of(j)
    #     level_found = false
    #     current_level = 0
    #     IO.puts("Comparing #{sha_j} and node #{sha_node}")

    #     level = Enum.reduce(1..40, 0,
    #             fn (x,y) -> 
    #             if (String.at(sha_j, x - 1) == String.at(sha_node, x-1) and y == x-1),  
    #             do: y + 1,
    #             else: y  
    #             end)
    #     # current_level_list = Enum.map(1..40, fn char_at -> 
    #     #     compare_char_at(char_at,sha_j,sha_node,current_level,level_found) 
    #     # end)
        
    #     #column = Enum.red
    #     IO.inspect(level)
    # end

    def hash_of(number) do
        hex_val = :crypto.hash(:sha, number |> Integer.to_string ) |> Base.encode16
        hex_val
    end
end