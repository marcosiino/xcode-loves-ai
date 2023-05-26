//
//  MessageModel.swift
//  ChatGPT-Client
//
//  Created by Marco on 27/04/23.
//

import Foundation

struct MessageModel: Codable {
    enum Role: String, Codable {
        case assistant = "assistant"
        case user = "user"
        case system = "system"
    }
    
    let role: Role
    let content: String
}

extension MessageModel: Identifiable {
    var id: UUID {
        return UUID()
    }
}
