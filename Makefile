UI_PATH = ui

all: init test build

.PHONY: init
init:
	@echo "> Installing dependencies ..."
	@go get -v ./...
	@go install github.com/markbates/pkger/cmd/pkger
	@cd ${UI_PATH} && yarn

.PHONY: build
build: ui-build server-build

.PHONY: ui-build
ui-build:
	@echo "> Building the UI ..."
	@cd ${UI_PATH} && rm -rf build && yarn build

.PHONY: server-build
server-build:
	@echo "> Packaging the UI ..."
	@rm -rf pkged.go && pkger
	@echo "> Building the server binary ..."
	@rm -rf bin && go build -o bin/patal main.go

.PHONY: test
test: ui-test server-test

.PHONY: ui-test
ui-test:
	@echo "> Testing the UI source code ..."
	@cd ${UI_PATH} && yarn test --coverage --watchAll=false

.PHONY: server-test
server-test:
	@echo "> Testing the server source code ..."
	@go test -v ./...

.PHONY: ui-lint-fix
ui-lint-fix:
	@echo "> Linting the UI source code ..."
	@cd ${UI_PATH} && yarn lint