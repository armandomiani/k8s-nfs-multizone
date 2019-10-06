CONTAINER_NAME = pvc-sample-api
CURRENT_PROJECT := $(shell gcloud config get-value project)
GCLOUD_CONTAINER_NAME = gcr.io/$(CURRENT_PROJECT)/$(CONTAINER_NAME)
CLUSTER = bandklub
ZONE = us-central1-a

build:
	docker build -t $(CONTAINER_NAME) api/


run:
	docker run -it -p 5000:5000 -d --name api $(CONTAINER_NAME)


attach:
	docker exec -it api bash


push:
	gcloud auth configure-docker
	docker tag $(CONTAINER_NAME) $(GCLOUD_CONTAINER_NAME)
	docker push $(GCLOUD_CONTAINER_NAME)


create_cluster:
	gcloud container clusters create $(CLUSTER) --zone $(ZONE)
	$(MAKE) get_credentials


get_credentials:
	gcloud container clusters get-credentials $(CLUSTER) --zone $(ZONE)


apply_manifests:
	kubectl apply -f k8s/api-statefulset.yaml
	kubectl apply -f k8s/api-service.yaml
	kubectl apply -f k8s/api-storage.yaml


delete_manifests:
	kubectl delete -f k8s/api-statefulset.yaml
	kubectl delete -f k8s/api-service.yaml
	kubectl delete -f k8s/api-storage.yaml


delete_pvc:
	kubectl delete pvc --all


public_url:
	kubectl get ingress sample-api-ingress \
  		--namespace default \
  		--output jsonpath='{.status.loadBalancer.ingress[0].ip}'

stop_all:
	docker stop `docker ps -q`
	docker rm `docker ps -aq`
