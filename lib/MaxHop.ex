defmodule TapestryDos.State do
    use GenServer
    def start_link(nodes,req) do
        GenServer.start_link(__MODULE__,[nodes,req], name: __MODULE__)
    end

    def init([nodes, req]) do
        count = 0
        max = 0
        {:ok, {nodes,req, count, max , %{}}}
    end

    def end_of_task() do
        GenServer.call(__MODULE__,{:end_of_task}, :infinity)
    end

    @spec task_comp :: any

    def task_comp() do
        GenServer.call(__MODULE__,{:task_comp})
    end

    def max() do
        GenServer.call(__MODULE__, {:get_max}, :infinity)
    end

    def increase_count(number_of_hops) do
        # IO.puts number_of_hops
        GenServer.cast(__MODULE__, {:completed, number_of_hops})
    end

    def handle_call({:end_of_task},_from,{nodes,req,count,max,request_per_node}) do
        isCompleted = count >= req * nodes
        {:reply,isCompleted,{nodes,req,count,max,request_per_node}}
    end

    def handle_call(
        {:task_comp},
        _from,
        {nodes,req,count,max,request_per_node}
    )
    do
        {:reply,count,{nodes,req,count,max,request_per_node}}
    end
    

    def handle_call({:get_max}, _from, {nodes,req,count,max,request_per_node}) do
        {:reply,max,{nodes,req,count,max,request_per_node}}
    end 

    def handle_cast({:completed, number_of_hops}, {nodes,req,count,max,request_per_node}) do
        max = 
        if max < number_of_hops do
            number_of_hops
        else
            max
        end

        {:noreply,{nodes,req,count + 1,max,request_per_node}}
    end
end