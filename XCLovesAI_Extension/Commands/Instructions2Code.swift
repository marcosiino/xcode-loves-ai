//
//  Instructions2Code.swift
//  XCLovesAI_Extension
//
//  Created by Marco on 26/05/23.
//  Copyright © 2023 Marco Siino. All rights reserved.
//

import Foundation
import XcodeKit

class Instructions2Code: NSObject, XCSourceEditorCommand, CodeEditorCommand, AIAssistedCommand {
    var messages: [MessageModel] = []
    var client = ChatGPTClient(apiKey: SourceEditorExtension.apiKey)
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        guard let (selectedText, _, _, _) = selectedTextBlock(from: invocation) else {
            completionHandler(nil)
            return
        }
        
        addAIInstructions(systemInstructions: "You are a code generation assistant for Xcode. I will give you some instructions via comments and you will replace them with actual code based on those instructions. Answer only with the raw code, without any markup language or text instructions. Only output executable code. Write the full code.")
        addAIMessageWithCode(code: selectedText)
        
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
