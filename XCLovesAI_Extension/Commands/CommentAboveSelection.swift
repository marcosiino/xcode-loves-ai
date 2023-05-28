//
//  CommentAboveSelection.swift
//  XCLovesAI_Extension
//
//  Created by Marco Siino on 25/05/23.
//

import Foundation
import XcodeKit

class CommentAboveSelection: NSObject, XCSourceEditorCommand, CodeEditorCommand, AIAssistedCommand {
    var messages: [MessageModel] = []
    var client = ChatGPTClient(apiKey: SourceEditorExtension.apiKey)
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        guard let selectedBlock = selectedTextBlock(from: invocation) else {
            completionHandler(nil)
            return
        }
        
        addAIInstructions(systemInstructions: "You are a code assistant for Xcode. Write a concise comment for this code that will be placed above the code and will help other developers to understand what it does in few words. Try to understand if the code is a function that needs an /// comment to generate the help documentation for xcode, otherwise generate a simple // comment.")
        addAIMessageWithCode(code: selectedBlock.selectedText)
        
        Task {
            do {
                if let comment = try await sendRequestToAI() {
                    invocation.buffer.lines.insert("\(selectedBlock.indentation)\(comment)", at: selectedBlock.startLine)
                }
                completionHandler(nil)
            }
        }
    }
}
