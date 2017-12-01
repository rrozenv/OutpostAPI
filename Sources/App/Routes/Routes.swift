import Vapor

extension Droplet {
   
    func setupRoutes() throws {
        let promptController = PromptController()
        promptController.addRoutes(drop: self)
        try resource("posts", PostController.self)
    }
    
}
