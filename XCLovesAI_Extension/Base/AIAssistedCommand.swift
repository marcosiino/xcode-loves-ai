//
//  AIAssistedCommand.swift
//  XCLovesAI_Extension
//
//  Created by Marco on 25/05/23.
//  Copyright © 2023 Marco Siino. All rights reserved.
//

import Foundation

enum AIRequestError: Error {
    case invalidResponse
}

protocol AIAssistedCommand: AnyObject {
    var messages: [MessageModel] { get set }
    var client: ChatGPTClient { get }
    
    /// Returns a message to setup the instructions for the AI
    func addAIInstructions(systemInstructions: String)
    
    /// Returns a message to send the code to the AI
    func addAIMessageWithCode(code: String)
    
    /// Sends the messages to the AI
    func sendRequestToAI() async throws -> String?
}

extension AIAssistedCommand {
    func addAIInstructions(systemInstructions: String) {
        messages.append(MessageModel(role: .system, content: systemInstructions))
    }
    
    func addAIMessageWithCode(code: String) {
        messages.append(MessageModel(role: .user, content: code))
    }
    
    func sendRequestToAI() async throws -> String? {
        do {
            if let result = try await client.sendMessages(messages:messages) {
                return result.choices.last?.message.content
            }
            else {
                throw AIRequestError.invalidResponse
            }
        }
    }
}
