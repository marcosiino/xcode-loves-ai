//
//  SourceEditorExtension.swift
//  XCLovesAI_Extension
//
//  Created by Marco on 25/05/23.
//

import Foundation
import XcodeKit

class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    
    static var apiKey: String {
        if let path = Bundle.main.path(forResource: "openai", ofType: "apikey") {
            do {
                return try String(contentsOfFile: path).trimmingCharacters(in: .whitespacesAndNewlines)
            }
            catch {
                fatalError("Cannot open openai.apikey from the extension's main bundle. Be sure you have created this file and you have placed the openai's api key inside of it")
            }
        }
        
        fatalError("Cannot find openai.apikey in the extension's main bundle. Be sure you have created this file with the openai's api key inside of it")
    }
    
    /*
    func extensionDidFinishLaunching() {
        // If your extension needs to do any work at launch, implement this optional method.
    }
    */
    
    /*
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
        // If your extension needs to return a collection of command definitions that differs from those in its Info.plist, implement this optional property getter.
        return []
    }
    */
    
}
