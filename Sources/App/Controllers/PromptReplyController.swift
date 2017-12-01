//
//  PromptReplyController.swift
//  Outpost
//
//  Created by Robert Rozenvasser on 12/1/17.
//

import Foundation
import Vapor
import HTTP

final class PromptReplyController: ResourceRepresentable {

    //GET/:id
    func show(_ req: Request, reply: PromptReply) throws -> ResponseRepresentable {
        return reply
    }
    
    //POST
    func store(_ req: Request) throws -> ResponseRepresentable {
        let reply = try req.promptReply()
        try reply.save()
        return reply
    }
    
    //DELETE/:id
    func delete(_ req: Request, reply: PromptReply) throws -> ResponseRepresentable {
        try reply.delete()
        return Response(status: .ok)
    }
    
    //DELETE ALL
    func clear(_ req: Request) throws -> ResponseRepresentable {
        try PromptReply.makeQuery().delete()
        return Response(status: .ok)
    }
    
    //PUT
    func replace(_ req: Request, reply: PromptReply) throws -> ResponseRepresentable {
        let new = try req.promptReply()
        reply.body = new.body
        try reply.save()
        return reply
    }
    
    func makeResource() -> Resource<PromptReply> {
        return Resource(
            store: store,
            show: show,
            replace: replace,
            destroy: delete,
            clear: clear
        )
    }
    
}

extension Request {
    func promptReply() throws -> PromptReply {
        guard let json = json else { throw Abort.badRequest }
        return try PromptReply(json: json)
    }
}

extension PromptController: EmptyInitializable { }
