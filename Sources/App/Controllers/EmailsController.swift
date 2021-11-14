import Vapor
import Smtp
import ExtendedConfiguration

final class EmailsController: RouteCollection {

    public static let uri: PathComponent = .constant("emails")

    func boot(routes: RoutesBuilder) throws {
         let accountGroup = routes.grouped(EmailsController.uri)
        
        accountGroup.post("send", use: send)
    }

    /// Sending email.
    func send(request: Request) async throws -> BooleanResponseDto {
        let emailDto = try request.content.decode(EmailDto.self)
        try EmailDto.validate(content: request)
        
        let fromAddress = emailDto.from?.address ?? request.application.settings.getString(for: "smtp.fromEmail", withDefault: "")
        let fromName = emailDto.from?.address ?? request.application.settings.getString(for: "smtp.fromName",withDefault: "")
        
        let email = try Email(from: EmailAddress(address: fromAddress, name: fromName),
                          to: [EmailAddress(address: emailDto.to.address, name: emailDto.to.name)],
                          subject: emailDto.subject,
                          body: emailDto.body)

        do {
            try await request.smtp.send(email)
            
            request.logger.info("Email to '\(emailDto.to.address)' has been sent.")
            return BooleanResponseDto(result: true)
        } catch (let error) {
            request.logger.error("Error during sending email: \(error)")
            return BooleanResponseDto(result: false)
        }
    }
}
