# Extensions for Protocol Buffers to create more go like structures.
#
# Copyright (c) 2013, Vastech SA (PTY) LTD. All rights reserved.
# http://github.com/nourish/protobuf/gogoproto
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

.PHONY: nuke regenerate tests clean install gofmt vet contributors

all: clean install regenerate install tests errcheck vet

buildserverall: clean install regenerate install tests vet

install:
	go install ./proto
	go install ./gogoproto
	go install ./jsonpb
	go install ./protoc-gen-gogo
	go install ./protoc-gen-gofast
	go install ./protoc-gen-gogofast
	go install ./protoc-gen-gogofaster
	go install ./protoc-gen-gogoslick
	go install ./protoc-min-version
	go install ./protoc-gen-combo

clean:
	go clean ./...

nuke:
	go clean -i ./...

gofmt:
	gofmt -l -s -w .

regenerate:
	make -C protoc-gen-gogo/descriptor regenerate
	make -C protoc-gen-gogo/plugin regenerate
	make -C protoc-gen-gogo/testdata regenerate
	make -C gogoproto regenerate
	make -C proto/testdata regenerate
	make -C jsonpb/jsonpb_test_proto regenerate
	make -C test regenerate
	make -C test/example regenerate
	make -C test/unrecognized regenerate
	make -C test/group regenerate
	make -C test/unrecognizedgroup regenerate
	make -C test/enumstringer regenerate
	make -C test/unmarshalmerge regenerate
	make -C test/moredefaults regenerate
	make -C test/issue8 regenerate
	make -C test/enumprefix regenerate
	make -C test/enumcustomname regenerate
	make -C test/packed regenerate
	make -C test/protosize regenerate
	make -C test/tags regenerate
	make -C test/oneof regenerate
	make -C test/oneof3 regenerate
	make -C test/theproto3 regenerate
	make -C test/mapsproto2 regenerate
	make -C test/issue42order regenerate
	make -C proto generate-test-pbs
	make -C test/importdedup regenerate
	make -C test/custombytesnonstruct regenerate
	make -C test/required regenerate
	make -C test/casttype regenerate
	make -C test/castvalue regenerate
	make -C vanity/test regenerate
	make -C test/sizeunderscore regenerate
	make -C test/issue34 regenerate
	make -C test/empty-issue70 regenerate
	make -C test/indeximport-issue72 regenerate
	make -C test/fuzztests regenerate
	make -C test/oneofembed regenerate
	make -C test/asymetric-issue125 regenerate
	make -C test/filedotname regenerate
	make gofmt

tests:
	go build ./test/enumprefix
	go test ./...

vet:
	go vet ./...
	go tool vet --shadow .

errcheck:
	go get -u github.com/kisielk/errcheck
	errcheck ./test/...

drone:
	sudo apt-get install protobuf-compiler
	(cd $(GOPATH)/src/github.com/nourish/protobuf && make buildserverall)

testall:
	make -C protoc-gen-gogo/testdata test
	make -C vanity/test test
	make tests

bench:
	(cd test/mixbench && go build .)
	(cd test/mixbench && ./mixbench)

contributors:
	git log --format='%aN <%aE>' | sort -fu > CONTRIBUTORS


