# Introduction
This repository allows you to set up an Aerospike Graph Server and run simple Gremlin queries against it. 

# Prerquisit   
1. You must have a valid Aerospike feature file. 
2. You need to have docker installed on your machine.

# How to Use
1. Clone this repository to your local machine.
2. Copy your features.conf (Containing the aerospike license) into the `./aerospike/` directory.
3. Change the current directory to the root of this repository. 
4. Run 'chmod `744 *.sh`.
5. Run './start.sh'

This should:
- Start an Aerospike Server
- Start an Aerospike Graph Server
- Start a Gremlin Console
- Load this dataset: https://github.com/krlawrence/graph/blob/master/sample-data/air-routes-latest.graphml
- Print the number of Vertices loaded:
- Allow you to run any Gremlin query. 

Notes:
- To exit the gremlin console, you should run `:q` or `:x`
- If you exit the console, the Aerospike and Graph servers will continue to run. To re-connect to the gremlin console, run `./gremlinConnect.sh`.

# Teardown
After you finish testing, run `./teardown.sh` to stop all the containers. 
