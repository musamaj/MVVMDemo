// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import Foundation

internal final class DelayConstraint: JobConstraint {

    func willSchedule(queue: SqOperationQueue, operation: SqOperation) throws {
        // Nothing to do
    }

    func willRun(operation: SqOperation) throws {
        // Nothing to do
    }

    func run(operation: SqOperation) -> Bool {
        guard let delay = operation.info.delay else {
            // No delay run immediately
            return true
        }

        let epoch = Date().timeIntervalSince(operation.info.createTime)
        guard epoch < delay else {
            // Epoch already greater than delay
            return true
        }

        let time: Double = abs(epoch - delay)

        operation.dispatchQueue.runAfter(time, callback: { [weak operation] in
            // If the operation in already deInit, it may have been canceled
            // It's safe to ignore the nil check
            // This is mostly to prevent job retention when cancelling operation with delay
            operation?.run()
        })

        operation.logger.log(.verbose, jobId: operation.info.uuid, message: "Job delayed by \(time)s")
        return false
    }
}
