//
//  SocketHelper.swift
//  AQI
//
//  Created by Rohan Chhatbar on 15/01/22.
//

import Foundation
import SwiftWebSocket

class SocketHelper : NSObject {
    
    static let instance = SocketHelper()
    
    private var ws = WebSocket("ws://city-ws.herokuapp.com")
    
    public var socketError : (_ error : Error)->() = {(error) in}
    public var message : (Any)->() = {(data) in}
    
    override init() {
        super.init()
        
        ws.event.message = { message in
            print("message: ",message)
            self.message(message)
        }
        
        ws.event.error = { error in
            print("error \(error)")
            self.socketError(error)
        }
    }
}
