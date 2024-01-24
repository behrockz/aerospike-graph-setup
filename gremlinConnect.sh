#!/bin/bash 

docker run --rm -it -v $(pwd)/gremlin/:/opt/gremlin/ --name gremlin tinkerpop/gremlin-console -i /opt/gremlin/define.groovy
