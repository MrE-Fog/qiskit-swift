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
 Exceptions raised due to errors in result output.
 It may be better for the QISKit API to raise this exception.
 Args:
     error (dict): This is the error record as it comes back from
     the API. The format is like::
        error = {'status': 403,
     '             'message': 'Your credits are not enough.',
                    'code': 'MAX_CREDITS_EXCEEDED'}
 */
public final class ResultError: CustomStringConvertible {

    public let status: String
    public let message: String
    public let code: String

    init(_ error: [String:Any]) {
        self.status = error["status"] as? String ?? ""
        self.message = error["message"] as? String ?? ""
        self.code = error["code"] as? String ?? ""
    }

    public var description: String {
        return "Error status:'\(self.status)' code:'\(self.code)' msg:'\(self.message)'"
    }
}
