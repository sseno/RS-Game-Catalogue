//
//  PrintDebug.swift
//  RS-Game-Catalogue
//
//  Created by Rohmat Suseno on 01/08/20.
//  Copyright © 2020 github.com/sseno. All rights reserved.
//

import Foundation

class PrintDebug {

    class func printDebugGeneral(_ object: Any, message: String) {
        #if DEBUG_GENERAL_MODE
        print("\(message): \(object)")
        #endif
    }

    class func printDebugService (_ object: Any, message:String) {
        #if DEBUG_SERVICE_MODE
            print("\(message): \(object)")
        #endif
    }
}
