// Copyright 2017 IBM RESEARCH. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// =============================================================================

import Foundation

/*
 Node for an OPENQASM qreg statement.
 children[0] is an indexedid node.
 */
public final class NodeQreg: Node {

    public let indexedid: Node
    public private(set) var _name: String = ""
    public private(set) var line: Int = 0
    public private(set) var file: String = ""
    public private(set) var index: Int = 0
    
    @objc public init(indexedid: Node, line: Int, file: String) {
        self.indexedid = indexedid
        if let _id = self.indexedid as? NodeIndexedId {
            // Name of the qreg
            self._name = _id.name
            // Source line number
            self.line = _id.line
            // Source file name
            self.file = _id.file
            // Size of the register
            self.index = _id.index
        }
    }
    
    public override var type: NodeType {
        return .N_QREG
    }
    
    public override var name: String {
        return _name
    }

    public override var children: [Node] {
        return [self.indexedid]
    }
    
    public override func qasm(_ prec: Int) -> String {
        return "qreg " + self.indexedid.qasm(prec) + ";"
    }
}
