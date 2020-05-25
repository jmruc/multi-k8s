# Build and tag images
docker build -t kirilraychev/multi-client:latest -t kirilraychev/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t kirilraychev/multi-server:latest -t kirilraychev/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t kirilraychev/multi-worker:latest -t kirilraychev/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# Push images to hub.docker.com
docker push kirilraychev/multi-client:latest
docker push kirilraychev/multi-client:$SHA
docker push kirilraychev/multi-server:latest
docker push kirilraychev/multi-server:$SHA
docker push kirilraychev/multi-worker:latest
docker push kirilraychev/multi-worker:$SHA

# apply the configuration to the k8s cluster
kubectl apply -f k8s

# set custom versions we just tagged
kubectl set image deployments/server-deployment server=kirilraychev/multi-server:$SHA
kubectl set image deployments/client-deployment client=kirilraychev/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=kirilraychev/multi-worker:$SHA