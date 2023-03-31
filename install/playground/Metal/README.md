## Meshery deployement in bar metal clusters 
#
1. pull the project : 

`git clone https://github.com/alaeddinebenhassir/meshery.git` \
`cd meshery`

2. set the fellowing env vars :

> `WORKER_NODE="{worker-hostname}"` \
> `MASTER_NODE="{Master-hostname}"` \
> `WORKER_SSH_KEY="{ssh-key-location}"`

3. Run the script

> `./install/playground/Metal/clusterReset.sh`

