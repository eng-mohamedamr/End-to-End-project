kubectl delete -f namespace.yml
kubectl delete -f config_map.yml
kubectl delete -f secrets.yml
kubectl delete -f statfulset.yml
kubectl delete -f back-deploy.yml
kubectl delete -f back-service.yml
kubectl delete -f front-deploy.yml
kubectl delete -f front-service.yml



