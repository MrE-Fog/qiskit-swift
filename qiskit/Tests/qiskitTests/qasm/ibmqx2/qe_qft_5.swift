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

// quantum Fourier transform for the Quantum Experience
// on all 5 qubits
struct QE_QFT_5 {
static let QASM = """
OPENQASM 2.0;
include "qelib1.inc";

// Register declarations
qreg q[5];
creg c[5];

// Choose starting state
// ** Put your code here **

// Quantum Fourier transform

// 0, 1, 2, 3, 4
h q[0];
// cu1(pi/2) q[0],q[1];
u1(pi/4) q[0];
cx q[0],q[1];
u1(-pi/4) q[1];
cx q[0],q[1];
u1(pi/4) q[1];
// end cu1
h q[1];
// cu1(pi/4) q[0],q[2];
u1(pi/8) q[0];
cx q[0],q[2];
u1(-pi/8) q[2];
cx q[0],q[2];
u1(pi/8) q[2];
// end cu1
// cu1(pi/2) q[1],q[2];
u1(pi/4) q[1];
cx q[1],q[2];
u1(-pi/4) q[2];
cx q[1],q[2];
u1(pi/4) q[2];
// end cu1
h q[2];
// cu1swp(pi/2) q[3],q[2];
cx q[3],q[2];
h q[3]; h q[2];
cx q[3],q[2];
h q[3]; h q[2];
u1(-pi/4) q[2];
cx q[3],q[2];
u1(pi/4) q[3];
u1(pi/4) q[2];
// end cu1swp
// 0, 1, 3, 2, 4
// cu1(pi/8) q[0],q[2];  // logically q[0],q[3]
u1(pi/16) q[0];
cx q[0],q[2];
u1(-pi/16) q[2];
cx q[0],q[2];
u1(pi/16) q[2];
// end cu1
// cu1(pi/4) q[1],q[2];  // logically q[1],q[3]
u1(pi/8) q[1];
cx q[1],q[2];
u1(-pi/8) q[2];
cx q[1],q[2];
u1(pi/8) q[2];
// end cu1
h q[2];               // logically q[3]
// cu1swp(pi/2) q[4],q[2]; // logically q[4],q[3]
cx q[4],q[2];
h q[4]; h q[2];
cx q[4],q[2];
h q[4]; h q[2];
u1(-pi/4) q[2];
cx q[4],q[2];
u1(pi/4) q[4];
u1(pi/4) q[2];
// end cu1swp
// 0, 1, 4, 2, 3
// cu1(pi/16) q[0],q[2]; // logically q[0],q[4]
u1(pi/32) q[0];
cx q[0],q[2];
u1(-pi/32) q[2];
cx q[0],q[2];
u1(pi/32) q[2];
// end cu1
// cu1(pi/8) q[1],q[2];  // logically q[1],q[4]
u1(pi/16) q[1];
cx q[1],q[2];
u1(-pi/16) q[2];
cx q[1],q[2];
u1(pi/16) q[2];
// end cu1
// cu1(pi/4) q[3],q[2];  // logically q[2],q[4]
u1(pi/8) q[3];
cx q[3],q[2];
u1(-pi/8) q[2];
cx q[3],q[2];
u1(pi/8) q[2];
// end cu1
h q[2];               // logically q[4]

// Outputs are q[2], q[4], q[3], q[1], q[0]

// Choose measurement
// ** Put your code here **

measure q -> c;
"""
}
