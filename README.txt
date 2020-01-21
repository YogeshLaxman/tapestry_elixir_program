TAPESTRY PROTOCOL IN ELIXIR - COP5615:

TEAM MEMBERS
Yogesh Laxman (UFID 9451 2517)
Sugandha Gupta (UFID 9768 9051)

PROBLEM SPECIFICATION
Design tapestry protocol using Genserver/Actor model in Elixir to implement the network join and routing as described in the Tapestry algorithm paper and encode the simple application that associates a key with a string.

INSTALLATION AND RUN

Elixir Mix project is required to be installed. 
Files of importance in the zipped folder (in order of call)

To run a test case, do:

1. Unzip contents to your desired elixir project folder.
2. Open cmd window from this project location (use $cd <location> to change location)
3. Type "mix run project3.exs <numNodes> <numRequests>" in commandline without quotes. 
4. The run terminates when all the nodes perform given number of requests (details in report). 
5. The result provides the max number of hops for the message to be delivered.

Example:
   C:\Users\Gupta\Documents\Elixir\tapestry_protocol>mix run project3.exs 1000 10
   Waiting for completion of Tapestry Protocol..
   Max number of hops:
   4
   Task ended
   
WHAT IS WORKING

1. Initially we have used the number of nodes given to create nodes.
2. We have then created 10 percent of the given nodes to create dynamic nodes.
3. The nodes are then updated according to the added nodes.
4. Message has been passed from each node to given number of random destination nodes.'
5. Max number of hops taken to reach the destination node is then displayed.
   
LARGEST NETWORK
    
   Largest network tested: 
   Largest Number of Nodes tested: 6000
   Largest Number of Requests: 100
   
   Sample:
   C:\Users\Gupta\Documents\Elixir\Tapestry_protocol>mix run entrypoint.exs 2000 100
   Waiting for completion of Tapestry Protocol..
   Max number of hops:
   4
   Task ended
