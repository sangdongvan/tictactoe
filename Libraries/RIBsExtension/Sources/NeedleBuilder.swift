//
//  Copyright (c) 2018. Uber Technologies
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR COITIONS OF ANY KI, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import RIBs

/// Utility that instantiates a RIB and sets up its internal wirings.
open class NeedleBuilder<ComponentType>: Buildable {

    /// The closure to instantiate a new instance of the DI component
    /// that should be paired with this RIB.
    public let componentBuilder: () -> ComponentType

    /// Initializer.
    ///
    /// - parameter componentBuilder: The closure to instantiate a new
    /// instance of the DI component that should be paired with this RIB.
    public init(componentBuilder: @escaping () -> ComponentType) {
        self.componentBuilder = componentBuilder
    }
}
