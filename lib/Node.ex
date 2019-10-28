defmodule TapestryDos.Node do
    
    use GenServer

    #-------------------------------------------API--------------------------------------#

    def start_link([x]) do
        GenServer.start_link(__MODULE__, [x])
    end

    def trace_destination(node_num, req,updated_nodes_pid_map) do
        pid = updated_nodes_pid_map["pid_#{node_num}"]
        GenServer.cast(pid, {:maximum_hops, node_num, req,updated_nodes_pid_map})
    end
    #---------------------------------Callback functions---------------------------------#

    def init([x]) do
        [node_number|routing_table_and_list_nodes] = x
        [routing_table|list_nodes_and_total_request] = routing_table_and_list_nodes
        [list_nodes|total_requests] = list_nodes_and_total_request
        hash_id= hash_of(node_number)
        msg_count=0
        {:ok,{hash_id, msg_count , routing_table , list_nodes, %{}, total_requests}}
    end

    def handle_cast({:kickoff}, {hash_id, msg_count , routing_table , list_nodes, hash_to_pid, total_requests}) do
        send(self(), {:start})
        {:noreply, {hash_id, msg_count , routing_table , list_nodes, hash_to_pid, total_requests}}
    end

    def handle_info({:start}, {hash_id, msg_count , routing_table , list_nodes, hash_to_pid, total_requests}) do
        msg_count = 
        if msg_count == total_requests do
            msg_count
        else
            search_hash = Enum.random(list_nodes -- [hash_id])
            GenServer.cast(Map.get(hash_to_pid, search_hash), {:search_node, search_hash, 0})
            Process.send_after(self(), {:start}, 1000)
            msg_count + 1
        end
        {:noreply, {hash_id, msg_count , routing_table , list_nodes, hash_to_pid, total_requests}}
    end

    def handle_cast({:update_routing_table, new_routing_table, new_hash_to_pid, new_list_node}, {hash_id, msg_count , routing_table , list_nodes, hash_to_pid, total_requests}) do
        {:noreply, {hash_id, msg_count , new_routing_table , new_list_node, new_hash_to_pid, total_requests}}
    end

    def handle_cast({:search_node, node_id, hop}, {hash_id, msg_count, routing_table, list_nodes, hash_to_pid, total_requests}) do
        common_length = common_length(hash_id, node_id, 0)

        if common_length != 40 do
            next_node = Enum.at(Enum.at(routing_table, common_length), String.to_integer(String.at(node_id, common_length), 16))
            GenServer.cast(Map.get(hash_to_pid, next_node), {:search_node, node_id, hop + 1})
        else
            TapestryDos.State.increase_count(hop)  
        end

        {:noreply, {hash_id, msg_count , routing_table , list_nodes, hash_to_pid, total_requests}}
    end

    def common_length(guid_1, guid_2, index) do
        if (index == 40 || String.at(guid_1, index) != String.at(guid_2, index)) do
            index
        else
            common_length(guid_1, guid_2, index + 1)

        end
    end

    def hash_of(number) do
       hex_val = :crypto.hash(:sha, number |> Integer.to_string ) |> Base.encode16
       hex_val
    end

    def hash_of(number) do
        hex_val = :crypto.hash(:sha, number |> Integer.to_string ) |> Base.encode16
        hex_val
    end
end