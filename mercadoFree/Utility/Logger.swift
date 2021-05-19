//
//  Logger.swift
//  mercadoFree
//
//  Created by Sergio Bernal on 18/05/21.
//

import Foundation

enum LogCase {
    case network
    case debug
    case other
    case error
}

class Logger {
    static let shared = Logger()
    
    func log<T: Any>(from className: T, with logCase: LogCase = .network, message: String) {
        switch logCase {
        case .network:
            print("📡 request \(Swift.type(of: className)) - \(message)")
        case .debug:
            print("💻 \(Swift.type(of: className)):: \(message)")
        case .other:
            print("📻 \(Swift.type(of: className)) - \(message)")
        case .error:
            print("🚫 \(Swift.type(of: className)) - \(message)")
        }
    }
    
    private init(){}
}
