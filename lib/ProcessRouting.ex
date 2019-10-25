defmodule TapestryDos.ProcessRouting do
    
    def hash_of(number) do
        hex_val = :crypto.hash(:sha, number |> Integer.to_string ) |> Base.encode16
        hex_val
    end

    def hello(node) do
        dht_guid = hash_of node
        guids = Enum.map(1..10000, fn n -> hash_of(n) end)

        Enum.map(0..39, fn level -> 
            Enum.map(0..15, fn column -> 
                prefix = 
                if level == 0 do
                    ""
                else
                    String.slice(dht_guid, 0..(level - 1))
                end

                currentHex = Integer.to_string(column, 16)
                newPrefix = "#{prefix}#{currentHex}"

                filteredGuids = Enum.filter(guids -- [dht_guid], fn g -> String.starts_with?(g, newPrefix) end)
                if(length(filteredGuids) == 0) do
                    nil
                else
                    Enum.random(filteredGuids)
                end
            end)
        end)
    end
end