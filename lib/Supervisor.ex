defmodule TapestryDos.DynamicNodeSupervisor do
    use DynamicSupervisor

    def start_link(_) do
        DynamicSupervisor.start_link(__MODULE__, :no_args, name: __MODULE__)
    end
    
    def init(:no_args) do
        DynamicSupervisor.init(strategy: :one_for_one)
    end

    def start_state(num_nodes, num_requests) do
        DynamicSupervisor.start_child(__MODULE__, %{
            id: State,
            start: {TapestryDos.State, :start_link, [num_nodes, num_requests]}
          })
    end

    def start_child_nodes(x) do
        {:ok, pid} =DynamicSupervisor.start_child(__MODULE__, %{
            id: Stack,
            start: {TapestryDos.Node, :start_link, [[x]]}
          })
        pid
    end
end