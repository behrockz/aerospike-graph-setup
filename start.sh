#!/bin/bash 

echo "==============================================================================="
echo "Starting Aerospike Server!"
docker run -tid --rm --name aerospike -p 3000:3000 -p 3001:3001 -p 3002:3002 \
    -v $(pwd)/aerospike:/etc/aerospike/ \
    -v $(pwd)/log:/var/log/aerospike/ \
    -e "features.conf=/etc/aerospike/features.conf" \
    aerospike/aerospike-server-enterprise

sleep 10;
if [ "$( docker container inspect -f '{{.State.Running}}' aerospike )" != "true" ] 
then
    echo "There was an error starting the Aerospike Server!"
    exit 1;
fi

aerospikeIp=$(docker inspect -f '{{.NetworkSettings.IPAddress }}' aerospike)

echo "Aerospike Server is up and running on: $aerospikeIp"
echo "==============================================================================="
echo "Starting Graph Server!"
docker run -p8182:8182 -id --rm --name graph -e aerospike.client.namespace="test" \
    -e aerospike.client.host="$aerospikeIp:3000, $aerospikeIp:3000" \
    -e aerospike.graph.index.vertex.properties=property1,property2 \
    -e aerospike.graph.index.vertex.label.enabled=true \
    -v $(pwd)/graph/:/opt/air-routes/ \
    aerospike/aerospike-graph-service

sleep 10;
if [ "$( docker container inspect -f '{{.State.Running}}' graph )" != "true" ]
then
    echo "There was an error starting the Graph Server!"
    exit 1;
fi

graphIp=$(docker inspect -f '{{.NetworkSettings.IPAddress }}' graph)
echo "Graph Service is up and Running on: $graphIp"
echo "==============================================================================="
echo "Starting Gremlin Console and loading the sample dataset:"

echo "g = AnonymousTraversalSource.traversal().withRemote(DriverRemoteConnection.using(\"$graphIp\", 8182, \"g\"))" > gremlin/load.groovy
echo "g.with(\"evaluationTimeout\", 24L * 60L * 60L * 1000L).io(\"/opt/air-routes/air-routes.graphml\").with(IO.reader, IO.graphml).read().iterate()" >> gremlin/load.groovy
echo "printf(\"%s vertices are loaded!\n\", g.V().toList().size())" >> gremlin/load.groovy

echo "g = AnonymousTraversalSource.traversal().withRemote(DriverRemoteConnection.using(\"$graphIp\", 8182, \"g\"))" > gremlin/define.groovy
 

docker run --rm -it -v $(pwd)/gremlin/:/opt/air-routes/ --name gremlin tinkerpop/gremlin-console -i /opt/air-routes/load.groovy
