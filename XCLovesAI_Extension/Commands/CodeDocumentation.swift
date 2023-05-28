//
//  CodeDocumentation.swift
//  XCLovesAI_Extension
//
//  Created by Marco Siino on 25/05/23.
//

import Foundation
import XcodeKit

class CodeDocumentation: NSObject, XCSourceEditorCommand, CodeEditorCommand, AIAssistedCommand {
    var messages: [MessageModel] = []
    var client = ChatGPTClient(apiKey: SourceEditorExtension.apiKey)
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        guard let selectedBlock = selectedTextBlock(from: invocation) else {
            completionHandler(nil)
            return
        }
        
        //Set instructions for the task ChatGPT should perform with our code
        addAIInstructions(systemInstructions: "You are a code assistant for Xcode. Generate code documentation for the given code. Only output the given code modified to add the documentation. Don't output any conversational text.")
        
        //Add a message with our code
        addAIMessageWithCode(code: selectedBlock.selectedText)
        
        Task {
            do {
                //Send the request to ChatGPT
                if let generatedAnswer = try await sendRequestToAI() {
                    replaceSelectedTextBlock(selectedBlock, with: generatedAnswer, inInvocation: invocation)
                }
                completionHandler(nil)
            }
        }
    }
}
