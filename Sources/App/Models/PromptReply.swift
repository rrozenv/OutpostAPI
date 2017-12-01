//
//  PromptReply.swift
//  Outpost
//
//  Created by Robert Rozenvasser on 12/1/17.
//

import Foundation
import Vapor
import FluentProvider

final class PromptReply: Model {
    
    struct Keys {
        static let id = "id"
        static let promptId = "promptId"
        static let userName = "userName"
        static let body = "body"
    }
    
    let storage = Storage()
    
    let promptId: Identifier
    var userName: String
    var body: String
    
    /// Creates a new Prompt
    init(promptId: Identifier, userName: String, body: String) {
        self.promptId = promptId
        self.userName = userName
        self.body = body
    }
    
    /// Initializes Prompt from row
    init(row: Row) throws {
        userName = try row.get(PromptReply.Keys.userName)
        body = try row.get(PromptReply.Keys.body)
        promptId = try row.get(PromptReply.Keys.promptId)
    }
    
    /// Serializes Prompt to database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(PromptReply.Keys.userName, userName)
        try row.set(PromptReply.Keys.body, body)
        try row.set(PromptReply.Keys.promptId, promptId)
        return row
    }
}

// MARK: Fluent Preparation

extension PromptReply: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Posts
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(PromptReply.Keys.userName)
            builder.string(PromptReply.Keys.body)
            builder.foreignId(for: Prompt.self)
        }
    }
    
    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON

// How the model converts from / to JSON.
// For example when:
//     - Creating a new Post (POST /posts)
//     - Fetching a post (GET /posts, GET /posts/:id)
//
extension PromptReply: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            promptId: try json.get(PromptReply.Keys.promptId),
            userName: try json.get(PromptReply.Keys.userName),
            body: try json.get(PromptReply.Keys.body)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(PromptReply.Keys.id, id)
        try json.set(PromptReply.Keys.promptId, promptId)
        try json.set(PromptReply.Keys.userName, userName)
        try json.set(PromptReply.Keys.body, body)
        return json
    }
}

extension PromptReply {
    var prompt: Parent<PromptReply, Prompt> {
        return parent(id: promptId)
    }
}

// MARK: HTTP

// This allows Post models to be returned
// directly in route closures
extension PromptReply: ResponseRepresentable { }

// MARK: Update

// This allows the Post model to be updated
// dynamically by the request.
//extension PromptReply: Updateable {
//
//    // Updateable keys are called when `post.update(for: req)` is called.
//    // Add as many updateable keys as you like here.
//    public static var updateableKeys: [UpdateableKey<Prompt>] {
//        return [
//            // If the request contains a String at key "content"
//            // the setter callback will be called.
//            UpdateableKey(PromptReply.Keys.title, String.self) { prompt, title in
//                prompt.title = title
//            }
//        ]
//    }
//}

