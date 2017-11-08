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
 Node for an OPENQASM custom gate body.
 children is a list of gate operation nodes.
 These are one of barrier, custom_unitary, U, or CX.
*/
public final class NodeGateBody: Node {
    
    public let goplist: Node?

    @objc override public init() {
        self.goplist = nil
    }

    @objc public init(goplist: Node) {
        self.goplist = goplist
    }
    
    public func calls() -> [String] {
        // Return a list of custom gate names in this gate body."""
        var _calls: [String] = []
        if let glist = goplist as? NodeGopList {
            for gop in glist.gateops {
                if gop.type == .N_CUSTOMUNITARY {
                    _calls.append(gop.name)
                }
            }
        }
        return _calls
    }
 
    public override var type: NodeType {
        return .N_GATEBODY
    }
   
    public override var children: [Node] {
        if let glist = goplist as? NodeGopList {
            return glist.children
        }
        return []
    }
    
    public override func qasm(_ prec: Int) -> String {
        var qasms: [String] = []
        if let glist = goplist as? NodeGopList {
            qasms = glist.children.flatMap({ (node: Node) -> String in
                return node.qasm(prec)
            })
        }
        return qasms.joined(separator: "\n")
    }
}
