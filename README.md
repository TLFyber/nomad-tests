# Nomad Tests

This repo has some experimental stuff relating to [Hashicorp Nomad](https://github.com/hashicorp/nomad):

* [A Docker image](nomad-agent/Dockerfile) - I couldn't get this to work - see comments in Vagrantfile, you need to share the Docker socket and /tmp - it still tried to assign the same IP to started containers
* Supervisord configs to run nomad on provisioned machines
* [A Sinatra app which handles Nomad's draining method](drainable-app/Dockerfile) - it sets a flag which changes the /health status code when it receives an INT signal

The last issue I encountered was that creating a job and running it would give a false-positive 'complete' status even
if the Nomad client couldn't pull the image or start it. 
