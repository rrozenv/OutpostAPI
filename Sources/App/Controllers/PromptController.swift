
import Foundation
import Vapor
import HTTP

final class PromptController {
    
    func addRoutes(drop: Droplet) {
        let basic = drop.grouped("prompts")
        basic.get(handler: index)
        basic.get(Prompt.parameter, handler: index)
        basic.get(Prompt.parameter, "replies", handler: repliesIndex)
        
        basic.post(handler: store)
        basic.post(Prompt.parameter, "replies", handler: storeReply)
    }
   
    //GET
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Prompt.all().makeJSON()
    }
    
    //GET/:id
    func show(_ req: Request, prompt: Prompt) throws -> ResponseRepresentable {
        return try prompt.makeJSON()
    }
    
    func repliesIndex(_ req: Request) throws -> ResponseRepresentable {
        let promptId = try req.parameters.next(Int.self)
        guard let prompt = try Prompt.find(promptId) else {
            throw Abort.notFound
        }
        return try prompt.replies.all().makeJSON()
    }
    
    //POST
    func storeReply(_ req: Request) throws -> ResponseRepresentable {
        let reply = try req.promptReply()
        try reply.save()
        return reply
    }
    
    func store(_ req: Request) throws -> ResponseRepresentable {
        let prompt = try req.prompt()
        try prompt.save()
        return prompt
    }
    
    //DELETE/:id
    func delete(_ req: Request, prompt: Prompt) throws -> ResponseRepresentable {
        try prompt.delete()
        return Response(status: .ok)
    }
    
    //DELETE ALL
    func clear(_ req: Request) throws -> ResponseRepresentable {
        try Prompt.makeQuery().delete()
        return Response(status: .ok)
    }
    
    //PATCH
    func update(_ req: Request, prompt: Prompt) throws -> ResponseRepresentable {
        try prompt.update(for: req)
        try prompt.save()
        return prompt
    }
    
    //PUT
    func replace(_ req: Request, prompt: Prompt) throws -> ResponseRepresentable {
        let new = try req.prompt()
        prompt.title = new.title
        try prompt.save()
        return prompt
    }
    
//    func makeResource() -> Resource<Prompt> {
//        return Resource(
//            index: index,
//            store: store,
//            show: show,
//            update: update,
//            replace: replace,
//            destroy: delete,
//            clear: clear
//        )
//    }
    
}

extension Request {
    func prompt() throws -> Prompt {
        guard let json = json else { throw Abort.badRequest }
        return try Prompt(json: json)
    }
}

extension PromptReplyController: EmptyInitializable { }
