//
//  JSONToCodable.swift
//  XCLovesAI_Extension
//
//  Created by Marco on 26/05/23.
//  Copyright © 2023 Marco Siino. All rights reserved.
//

import Foundation
import XcodeKit

class JSONToCodable: NSObject, XCSourceEditorCommand, CodeEditorCommand, AIAssistedCommand {
    var messages: [MessageModel] = []
    var client = ChatGPTClient(apiKey: SourceEditorExtension.apiKey)
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        guard let selectedBlock = selectedTextBlock(from: invocation) else {
            completionHandler(nil)
            return
        }
        
        addAIInstructions(systemInstructions: "You are a code assistant for Xcode. Write a swift codable model from the json code. Answer only with the raw codable model code, without any markup and without any other text or written instructions.")
        addAIMessageWithCode(code: selectedBlock.selectedText)
        
        Task {
            do {
                if let responseCode = try await sendRequestToAI() {
                    invocation.buffer.lines.removeAllObjects()
                    let lines = responseCode.split(separator: "\n")
                        .map { String($0) }
                        .filter { !$0.hasPrefix("```") } //Skip code markup lines
                    invocation.buffer.lines.addObjects(from: lines)
                }
                completionHandler(nil)
            }
        }
    }
}
