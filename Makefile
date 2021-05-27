VGO=go # Set to vgo if building in Go 1.10
BINARY_NAME=chainwall
GOFILES := $(shell find . -name '*.go' -print)
.DELETE_ON_ERROR:

all: build test
test: deps lint
		$(VGO) test  ./... -cover -coverprofile=coverage.txt -covermode=atomic
coverage.html:
		$(VGO) tool cover -html=coverage.txt
coverage: test coverage.html
ethbinding.so: ${GOFILES}
		go build -o ethbinding.so -buildmode=plugin -tags=prod -v
lint:
		$(shell go list -f '{{.Target}}' github.com/golangci/golangci-lint/cmd/golangci-lint) run
build: ethbinding.so
clean: 
		$(VGO) clean
		rm -f *.so
builddeps:
		$(VGO) get github.com/golangci/golangci-lint/cmd/golangci-lint
deps: builddeps
		$(VGO) get