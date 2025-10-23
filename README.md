## An docker image for the [Necesse Server](https://necessegame.com/server), made by drifty

The official images do not exist, so I created a Dockerfile and other related files to create the docker image. Useful for anyone who wants to run a Necesse server containerized.

How to use: - 

1. Download the compose.yml file.
2. Edit the ```SERVER_OPTS``` and possibly ```JAVA_OPTS``` enironment variables according to what your system can handle.
3. Run ```docker compose up -d```.
4. Run ```docker logs -f necesse-server``` if you want to see the logs.
5. Run ```docker attach necesse-server``` if you want to do stuff in the server console, and use ```Cntl + P``` and ```Cntl + Q``` to detach from the container after you are done.
6. Voila your server is running on port 14159 (unless you changed it in the compose file).
7. Remember, you need to manage port forwarding etc. yourself if you want this server to be joinable from the internet, this docker image doesn't deal with any of that. 
