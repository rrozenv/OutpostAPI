
import Foundation
import Vapor
import HTTP

final class PromptController: ResourceRepresentable {
   
    //GET
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Prompt.all().makeJSON()
    }
    
    //GET/:id
    func show(_ req: Request, prompt: Prompt) throws -> ResponseRepresentable {
        return prompt
    }
    
    //POST
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
    
    func makeResource() -> Resource<Prompt> {
        return Resource(
            index: index,
            store: store,
            show: show,
            update: update,
            replace: replace,
            destroy: delete,
            clear: clear
        )
    }
    
}

extension Request {
    func prompt() throws -> Prompt {
        guard let json = json else { throw Abort.badRequest }
        return try Prompt(json: json)
    }
}

extension PromptController: EmptyInitializable { }
