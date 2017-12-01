import Vapor

extension Droplet {
   
    func setupRoutes() throws {
        try resource("prompts", PromptController.self)
        try resource("posts", PostController.self)
    }
    
}
