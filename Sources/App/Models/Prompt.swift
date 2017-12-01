//
//  Prompt.swift
//  Outpost
//
//  Created by Robert Rozenvasser on 11/30/17.
//

import Foundation
import Vapor
import FluentProvider

final class Prompt: Model {
    
    struct Keys {
        static let id = "id"
        static let title = "title"
    }
    
    let storage = Storage()
    var title: String
    
    /// Creates a new Prompt
    init(title: String) {
        self.title = title
    }
    
    /// Initializes Prompt from row
    init(row: Row) throws {
        title = try row.get(Prompt.Keys.title)
    }
    
    /// Serializes Prompt to database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Prompt.Keys.title, title)
        return row
    }
}

// MARK: Fluent Preparation

extension Prompt: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Posts
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Prompt.Keys.title)
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
extension Prompt: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            title: try json.get(Prompt.Keys.title)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Prompt.Keys.id, id)
        try json.set(Prompt.Keys.title, title)
        return json
    }
}

// MARK: HTTP

// This allows Post models to be returned
// directly in route closures
extension Prompt: ResponseRepresentable { }

// MARK: Update

// This allows the Post model to be updated
// dynamically by the request.
extension Prompt: Updateable {
    
    // Updateable keys are called when `post.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<Prompt>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.
            UpdateableKey(Prompt.Keys.title, String.self) { prompt, title in
                prompt.title = title
            }
        ]
    }
}
