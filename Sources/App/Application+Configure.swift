import Vapor
import ExtendedError
import ExtendedConfiguration
import Smtp

extension Application {

    /// Called before your application initializes.
    public func configure() throws {
        // Register routes to the router.
        try routes()

        // Read configuration.
        try initConfiguration()
        
        // Configure smtp settings.
        configureSmtp()
        
        // Register middleware.
        registerMiddlewares()
    }

    /// Register your application's routes here.
    private func routes() throws {
        // Basic response.
        self.get { req in
            return "Service is up and running!"
        }

        // Configuring controllers.
        try self.register(collection: EmailsController())
    }
    
    private func registerMiddlewares() {
        // Catches errors and converts to HTTP response.
        let errorMiddleware = CustomErrorMiddleware()
        self.middleware.use(errorMiddleware)
    }
    
    private func initConfiguration() throws {
        self.logger.info("Init configuration for environment: \(self.environment.name)")
        
        try self.settings.load([
            .jsonFile("appsettings.json", optional: false),
            .jsonFile("appsettings.\(self.environment.name).json", optional: true),
            .jsonFile("appsettings.local.json", optional: true),
            .environmentVariables(.withPrefix("smtp"))
        ])
                
        self.settings.configuration.all().forEach { (key: String, value: Any) in
            self.logger.info("Configuration: \(key), value: \(value)")
        }
    }

    private func configureSmtp() {
        
        smtp.configuration.hostname = self.settings.getString(for: "smtp.hostname", withDefault: "")
        smtp.configuration.port = self.settings.getInt(for: "smtp.port", withDefault: 465)
        
        let username = self.settings.getString(for: "smtp.username", withDefault: "")
        let password = self.settings.getString(for: "smtp.password", withDefault: "")
        
        if username.isEmpty {
            smtp.configuration.signInMethod = .anonymous
        } else {
            smtp.configuration.signInMethod = .credentials(username: username, password: password)
        }
        
        switch self.settings.getString(for: "smtp.secure") {
        case "ssl":
            smtp.configuration.secure = .ssl
            break;
        case "startTls":
            smtp.configuration.secure = .startTls
            break;
        case "startTlsWhenAvailable":
            smtp.configuration.secure = .startTlsWhenAvailable
            break;
        default:
            smtp.configuration.secure = .none
            break;
        }

        self.logger.info("Smtp configuration server: \(smtp.configuration.hostname)")
    }
}
