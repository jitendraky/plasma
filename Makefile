BASE_PACKAGE=github.com/openfresh/plasma
VERSION=$(shell git rev-parse --verify HEAD)

SERIAL_PACKAGES= \
		 manager \
		 pubsub \
		 server \
		 subscriber
TARGET_SERIAL_PACKAGES=$(addprefix test-,$(SERIAL_PACKAGES))

install-go:
		sh util/go.sh 1.8.2

install-dep:
		go get -u github.com/golang/dep/cmd/dep

deps: install-dep
		dep ensure

deps-update: install-dep
		rm -rf ./vendor
		dep ensure -update

build:
		GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o bin/plasma main.go

test: $(TARGET_SERIAL_PACKAGES)

$(TARGET_SERIAL_PACKAGES): test-%:
		go test $(BASE_PACKAGE)/$(*)

gen-proto:
		cd protobuf && protoc --go_out=plugins=grpc:. *.proto
