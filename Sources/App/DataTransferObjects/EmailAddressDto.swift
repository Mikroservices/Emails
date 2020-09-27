import Vapor

struct EmailAddressDto {
    var address: String
    var name: String?
}

extension EmailAddressDto: Content { }

extension EmailAddressDto: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("address", as: String.self, is: .email)
    }
}
