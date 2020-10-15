# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
PROTOC=protoc
BINARY_NAME=user
DOCKER=docker
GITVER=`git rev-parse --short HEAD`

all: push
build: grpc
	GOOS=linux GOARCH=amd64 $(GOBUILD) SW/document
grpc:
	$(PROTOC) --go_out=plugins=grpc:../../../  --proto_path=. proto/user.proto
test:
	$(GOTEST) -v ./...
docker: build 
	docker build -f Dockerfile -t $(BINARY_NAME):$(GITVER) .
push: docker
	docker tag $(BINARY_NAME):$(GITVER) arc-repo.tencentcloudcr.com/arc/$(BINARY_NAME):$(GITVER)
	docker push arc-repo.tencentcloudcr.com/arc/$(BINARY_NAME):$(GITVER)
clean:
	$(GOCLEAN)
	rm -f $(BINARY_NAME)
run: grpc
	$(GOBUILD) SW/document	
	./$(BINARY_NAME)
