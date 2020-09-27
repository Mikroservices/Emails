import Vapor

struct EmailDto {
    var to: EmailAddressDto
    var subject: String
    var body: String
    var from: EmailAddressDto?
    var replyTo: EmailAddressDto?
}

extension EmailDto: Content { }

extension EmailDto: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("to") { (nestedValidation) in
            EmailAddressDto.validations(&nestedValidation)
        }
    }
}
