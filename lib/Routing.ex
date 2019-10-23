defmodule TapestryDos.Routing do
    def build_routing_tables (num_nodes) do
        #Take SHA of i compare it with every j and arrange accordingly
        Enum.map(1..num_nodes, fn i -> 
            compare_sha_of(i,num_nodes) 
        end)
    end

    def compare_sha_of(node,num_nodes) do
        Enum.map(1..num_nodes, fn j -> 
            with_sha_of(j,node) 
        end)
    end

    def with_sha_of(j,node) do
        sha_node = hash_of(node)
        sha_j = hash_of(j)
        level_found = false
        current_level = 1
        current_level_list = Enum.map(1..40, fn char_at -> 
            compare_char_at(char_at,sha_j,sha_node,current_level,level_found) 
        end)
        IO.inspect(current_level)
    end

    def compare_char_at(char_at,sha_j,sha_node,current_level,level_found) do
        char_at_j = String.at(sha_j, char_at)
        char_at_node = String.at(sha_j, char_at)
        if char_at_j == char_at_node and !level_found do
            current_level = current_level + 1
        else
            level_found = true
        end
        current_level
    end

    def hash_of(number) do
        hex_val = :crypto.hash(:sha, number |> Integer.to_string ) |> Base.encode16
        hex_val
     end
end