IMG := deeplythink/registry-proxy
VERSION := v1.0.0

.PHONY: build
build:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o bin/amd64/registry-proxy main.go
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o bin/arm64/registry-proxy main.go
	- docker buildx use gobuilder
	- docker buildx create --use --name gobuilder
	docker buildx build --platform linux/amd64,linux/arm64 -t $(IMG):$(VERSION) --push .
	docker buildx build --platform linux/amd64,linux/arm64 -t $(IMG):latest --push .

.PHONY: deploy
deploy:
	kubectl apply -f deploy/manifests.yaml

.PHONY: undeploy
undeploy:
	kubectl delete -f deploy/manifests.yaml
