@testable import App
import XCTVapor
import Foundation

final class SendActionTests: XCTestCase {
    func testEmailShouldBeSendForCorrectEmail() throws {
        // Arrange.
        try createSettingsFile()
        let app = Application(.testing)
        defer { app.shutdown() }
        try app.configure()

        // Act.
        let email = EmailDto(to: EmailAddressDto(address: "test@mczachurski.dev"),
                             subject: "Subject (testSendEmailShoudReturnStatus)",
                             body: "Body (testSendEmailShoudReturnStatus)")
        let emailData = try JSONEncoder().encode(email)
        
        // Assert.
        try app.test(.POST, "emails/send",
                     headers: ["Content-Type": "application/json"],
                     body: ByteBuffer(data: emailData),
                     afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let booleanResponse = try JSONDecoder().decode(BooleanResponseDto.self, from: res.body.string.data(using: .utf8)!)
            XCTAssertTrue(booleanResponse.result)
        })
        sleep(3)
    }
    
    func testEmailShouldNotBeSendWhenEmailAddressWasNotSpecified() throws {
        // Arrange.
        try createSettingsFile()
        let app = Application(.testing)
        defer { app.shutdown() }
        try app.configure()

        // Act.
        let email = EmailDto(to: EmailAddressDto(address: ""),
                             subject: "Subject (testSendEmailShoudReturnStatus)",
                             body: "Body (testSendEmailShoudReturnStatus)")
        let emailData = try JSONEncoder().encode(email)
        
        // Assert.
        try app.test(.POST, "emails/send",
                     headers: ["Content-Type": "application/json"],
                     body: ByteBuffer(data: emailData),
                     afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertContains(res.body.string, "Validation errors occurs.")
        })
        sleep(3)
    }
    
    private func createSettingsFile() throws {
        let content = """
        {
            "smtp": {
                "fromName": "John Doe",
                "fromEmail": "from@mczachurski.dev",
                "hostname": "smtp.mailtrap.io",
                "port": 465,
                "username": "#MAILTRAPUSER#",
                "password": "#MAILTRAPPASS#",
                "secure": "none"
            }
        }
        """
        
        let filePath: URL = URL(fileURLWithPath: "appsettings.json")
        let data = content.data(using: .utf8)!
        try data.write(to: filePath, options: .atomic)
    }
}
