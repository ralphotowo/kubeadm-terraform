if [ "$#" -ne 3 ]; then
  echo "Usage: $0 MASTERS WORKERS LOAD_BALANCER" >&2
  exit 1
fi
masters=$1
workers=$2
loadbalancer=$3
echo 'Setting up CA'
sh -x setup-ca.sh
sleep 5
echo 'Setting up certs'
sh -x setup-certs.sh $masters $workers $loadbalancer
sleep 5
echo 'Setting up kubeconfig'
sh -x generate-kubeconfig.sh $workers $loadbalancer
sleep 5
echo 'Distributing certs'
sh -x distribute-certs.sh $masters $workers
sleep 5
echo 'Distributing kubeconfig'
sh -x distribute-kubeconfig.sh $masters $workers
sleep 5
echo 'Generating data encode config'
sh -x generate-data-enc.config.sh $masters
sleep 5
echo 'Setting up etcd'
sh -x setup-etcd.sh $masters
sleep 5
echo 'Setting up Control Plane'
sh -x setup-master.sh $masters
sleep 5
echo 'Setting up RBAC'
sh -x setup-rbac.sh $masters
sleep 5
echo 'Setting up NGINX Load Balancer'
sh -x setup-nginx.sh $loadbalancer
sleep 5
echo 'Setting up Worker nodes'
sh -x setup-worker.sh $workers
sleep 5
echo 'Setting up networking'
sh -x setup-networking.sh $masters
sleep 5
echo 'Running Smoke test'
sh -x run-smoke-test.sh $masters
sleep 5
echo 'Done...'