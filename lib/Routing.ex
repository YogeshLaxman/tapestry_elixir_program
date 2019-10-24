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
        IO.puts("Comparing j #{j} and node #{node}")
        sha_node = hash_of(node)
        sha_j = hash_of(j)
        level_found = false
        current_level = 0
        IO.puts("Comparing #{sha_j} and node #{sha_node}")

        level = Enum.reduce(1..40, 0,
                fn (x,y) -> 
                if (String.at(sha_j, x - 1) == String.at(sha_node, x-1) and y == x-1),  
                do: y + 1,
                else: y  
                end)
        # current_level_list = Enum.map(1..40, fn char_at -> 
        #     compare_char_at(char_at,sha_j,sha_node,current_level,level_found) 
        # end)
        IO.inspect(level)
    end

    # def compare_char_at(char_at,sha_j,sha_node,current_level,level_found) do
    #     char_at = char_at - 1
    #     char_at_j = String.at(sha_j, char_at)
    #     char_at_node = String.at(sha_node, char_at)
    #     IO.puts("Comparing char_at #{char_at} of #{sha_j} and node #{sha_node} ie #{char_at_j} and #{char_at_node}")
    #     IO.puts("Current level initial #{current_level}")
    #    # Enum.reduce(1..8, 0, fn (x,y) -> if (String.at(d, x - 1) == String.at(e, x-1)),  do: y + 1,  else: y  end)
    #     current_level = if char_at_j == char_at_node and !level_found, do: increase_current_level(current_level), else: level_found = true
    #     # if char_at_j == char_at_node and !level_found do
    #     #     current_level = current_level + 1
    #     #     IO.puts("Current level should increase here #{current_level}")
    #     # else
    #     #     level_found = true
    #     # end

    #     # if char_at_j == char_at_node and !level_found do
    #     #     increase_current_level(current_level)
    #     # else
    #     #     level_found = true
    #     # end
        
    #     #if current_level 
      
    # end

    #     IO.puts("Current level final #{current_level}")
    #     current_level
    # end

    # def increase_current_level(num) do
    #     num = num + 1
    # end

    def hash_of(number) do
        hex_val = :crypto.hash(:sha, number |> Integer.to_string ) |> Base.encode16
        hex_val
    end
end