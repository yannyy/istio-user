package main

import (
	"context"
	"fmt"
	"log"
	"net"

	"os"

	pb "github.com/yannyy/istio-user/proto"
	"google.golang.org/grpc"
)

const (
	port = ":8085"
)

type server struct {
}

func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
	return &pb.HelloReply{Greeting: "Hello " + in.GetName()}, nil
}

var (
	defaultPort = "80" //默认端口
)

func main() {
	port := os.Getenv("PORT")
	bind := os.Getenv("BIND")
	if port == "" {
		port = defaultPort
	}
	url := fmt.Sprintf("%s:%s", bind, port)

	lis, err := net.Listen("tcp", url)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	s := grpc.NewServer()
	pb.RegisterUserServer(s, &server{})
	s.Serve(lis)
}
