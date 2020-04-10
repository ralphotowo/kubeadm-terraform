workers=$1
for instance in $(echo $workers | tr ',' ' '); do
  ZONE=`gcloud compute instances list | grep ${instance} | awk '{ print $2 }'`
  gcloud compute scp --zone=$ZONE bootstrap-worker.sh ${instance}:~/
  gcloud compute ssh --zone=$ZONE ${instance} -- "cd ~/ && sh -x bootstrap-worker.sh"
done
