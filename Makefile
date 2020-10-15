# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
PACKAGE=github.com/yannyy/istio-user
PROTOC=protoc
BINARY_NAME=istio-user
DOCKER=docker
GITVER=`git rev-parse --short HEAD`

all: push
build: grpc test
	GOOS=linux GOARCH=amd64 $(GOBUILD) 
grpc:
	$(PROTOC) --go_out=plugins=grpc:../../../  --proto_path=. proto/user.proto
test:
	$(GOTEST) -v ./...
docker: build 
	docker build -f Dockerfile -t $(BINARY_NAME):$(GITVER) .
clean:
	$(GOCLEAN)
	rm -f $(BINARY_NAME)
run: grpc
	$(GOBUILD) $(PACKAGE)
	./$(BINARY_NAME)
