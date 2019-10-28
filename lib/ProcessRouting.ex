defmodule TapestryDos.ProcessRouting do
    
    def hash_of(number) do
        hex_val = :crypto.hash(:sha, number |> Integer.to_string ) |> Base.encode16
        hex_val
    end

    def make_routing_table(node, node_num_list ) do
        hash_of_node = hash_of node
        list_of_node_hash = Enum.map(node_num_list, fn n -> hash_of(n) end)

        Enum.map(0..39, fn level -> 
            Enum.map(0..15, fn column -> 
                prefix = 
                if level == 0 do
                    ""
                else
                    String.slice(hash_of_node, 0..(level - 1))
                end

                current_hex = Integer.to_string(column, 16)
                new_prefix = "#{prefix}#{current_hex}"

                filtered_hash = Enum.filter(list_of_node_hash -- [hash_of_node], fn g -> String.starts_with?(g, new_prefix) end)
                if(length(filtered_hash) == 0) do
                    nil
                else
                    Enum.min(filtered_hash)
                end
            end)
        end)
    end

    def update_routing_table(node, node_num_list ) do
        hash_of_node = hash_of node
        list_of_node_hash = Enum.map(node_num_list, fn n -> hash_of(n) end)
        Enum.map(0..39, fn level ->  Enum.map(0..15, fn column -> 
                prefix = 
                if level == 0 do
                    ""
                else
                    String.slice(hash_of_node, 0..(level - 1))
                end
                current_hex = Integer.to_string(column, 16)
                new_prefix = "#{prefix}#{current_hex}"
                filtered_hash = Enum.filter(list_of_node_hash -- [hash_of_node],
                fn g -> String.starts_with?(g, new_prefix) 
                end)
                if(length(filtered_hash) == 0) do
                    nil
                else
                    Enum.min(filtered_hash)
                end
            end)
        end)
    end

end