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

/**
 Contains functions used by the simulators.

 Author: Jay Gambetta and John Smolin

 Functions
 index2 -- Takes a bitstring k and inserts bits b1 as the i1th bit
 and b2 as the i2th bit

 enlarge_single_opt(opt, qubit, number_of_qubits) -- takes a single qubit
 operator opt to a opterator on n qubits

 enlarge_two_opt(opt, q0, q1, number_of_qubits) -- takes a two-qubit
 operator opt to a opterator on n qubits

 */
final class SimulatorTools {

    private init() {
    }

    /**
     Magic index1 function.

     Takes a bitstring k and inserts bit b as the ith bit,
     shifting bits >= i over to make room.
    */
    static func index1(_ b: Int, _ i: Int, _ k: Int) -> Int {
        var retval = k
        let lowbits = k & ((1 << i) - 1)  // get the low i bits

        retval >>= i
        retval <<= 1

        retval |= b

        retval <<= i
        retval |= lowbits

        return retval
    }

    /**
     Magic index2 function.

     Takes a bitstring k and inserts bits b1 as the i1th bit
     and b2 as the i2th bit
     */
    static func index2(_ b1: Int, _ i1: Int, _ b2: Int, _ i2: Int, _ k: Int) -> Int {
        assert(i1 != i2)
        var retval: Int = 0
        if i1 > i2 {
            // insert as (i1-1)th bit, will be shifted left 1 by next line
            retval = index1(b1, i1-1, k)
            retval = index1(b2, i2, retval)
        }
        else { // i2>i1
            // insert as (i2-1)th bit, will be shifted left 1 by next line
            retval = index1(b2, i2-1, k)
            retval = index1(b1, i1, retval)
        }
        return retval
    }

    /**
     Enlarge single operator to n qubits.

     It is exponential in the number of qubits.

     Args:
        opt: the single-qubit opt.
        qubit: the qubit to apply it on counts from 0 and order
            is q_{n-1} ... otimes q_1 otimes q_0.
        number_of_qubits: the number of qubits in the system.
     */
    static func enlarge_single_opt(_ opt: Matrix<Complex>, _ qubit: Int, _ number_of_qubits: Int) -> Matrix<Complex> {
        let temp_1 = Matrix<Complex>.identity(Int(pow(2.0,Double(number_of_qubits-qubit-1))))
        let temp_2 = Matrix<Complex>.identity(Int(pow(2.0,Double(qubit))))
        return temp_1.kron(opt.kron(temp_2))
    }

    /**
     Enlarge two-qubit operator to n qubits.

     It is exponential in the number of qubits.
     opt is the two-qubit gate
     q0 is the first qubit (control) counts from 0
     q1 is the second qubit (target)
     returns a complex numpy array
     number_of_qubits is the number of qubits in the system.
     */
    static func enlarge_two_opt(_ opt: Matrix<Complex>, _ q0: Int, _ q1: Int, _ num: Int) -> Matrix<Complex> {
        var enlarge_opt = Matrix<Complex>(rows: 1 << (num), cols: 1 << (num), repeating: 0)
        for i in 0..<(1 << (num-2)) {
            for j in 0..<2 {
                for k in 0..<2 {
                    for jj in 0..<2 {
                        for kk in 0..<2 {
                            enlarge_opt[index2(j, q0, k, q1, i),index2(jj, q0, kk, q1, i)] = opt[j+2*k,jj+2*kk]
                        }
                    }
                }
            }
        }
        return enlarge_opt
    }

    /**
     Apply a single qubit gate to the qubit.

     Args:
        gate(str): the single qubit gate name
        params(list): the operation parameters op['params']
     Returns:
        a tuple of U gate parameters (theta, phi, lam)
     */
    static func single_gate_params(_ gate: String, _ _params: [Double]? = nil) -> (Double,Double,Double) {
        guard let params = _params else {
            return (0.0, 0.0, 0.0)
        }
        if gate == "U" || gate == "u3" {
            return (params[0], params[1], params[2])
        }
        else if gate == "u2" {
            return (Double.pi / 2.0, params[0], params[1])
        }
        else if gate == "u1" {
            return (0.0, 0.0, params[0])
        }
        else if gate == "id" {
            return (0.0, 0.0, 0.0)
        }
        return (0.0, 0.0, 0.0)
    }

    /**
     Get the matrix for a single qubit.

     Args:
        params(list): the operation parameters op['params']
     Returns:
        A numpy array representing the matrix
     */
    static func single_gate_matrix(_ gate: String, _ params: [Double]? = nil) -> Matrix<Complex> {
        let (theta, phi, lam) = SimulatorTools.single_gate_params(gate, params)
        return [[
                    Complex(real:cos(theta/2.0)),
                    Complex(imag: lam).exp() * -sin(theta/2.0)
                ],
                [
                    Complex(imag: phi).exp() * sin(theta/2.0),
                    (Complex(imag: phi) + Complex(imag: lam)).exp() * cos(theta/2.0)
                ]
        ]
    }
}
