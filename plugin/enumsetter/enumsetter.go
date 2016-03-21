// Copyright (c) 2013, Vastech SA (PTY) LTD. All rights reserved.
// http://github.com/nourish/protobuf
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//     * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
// copyright notice, this list of conditions and the following disclaimer
// in the documentation and/or other materials provided with the
// distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

/*
The enumstringer (experimental) plugin generates a String method for each enum.

It is enabled by the following extensions:

  - enum_stringer
  - enum_stringer_all

This package is subject to change.

*/
package enumsetter

import "github.com/nourish/protobuf/protoc-gen-gogo/generator"

type plugin struct {
	*generator.Generator
	generator.PluginImports
	atleastOne bool
	localName  string
}

func NewEnumSetter() *plugin {
	return &plugin{}
}

func (p *plugin) Name() string {
	return "enumsetter"
}

func (p *plugin) Init(g *generator.Generator) {
	p.Generator = g
}

func (p *plugin) Generate(file *generator.FileDescriptor) {
	p.PluginImports = generator.NewPluginImports(p.Generator)
	// p.atleastOne = false

	// p.localName = generator.FileName(file)

	for _, enum := range file.Enums() {
		p.P(``)
		// p.atleastOne = true
		ccTypeName := generator.CamelCaseSlice(enum.TypeName())
		p.P("func (x *", ccTypeName, ") SetIntValue(v int) {")
		p.In()
		p.P(`*x = `, ccTypeName, `(v)`)
		p.Out()
		p.P(`}`)
	}

}

func init() {
	generator.RegisterPlugin(NewEnumSetter())
}
