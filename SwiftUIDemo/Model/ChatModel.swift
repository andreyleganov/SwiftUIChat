import Foundation

struct Chat: Identifiable {
    var id: UUID { person.id}
    let person: Person
    var messages: [Message]
    var hasUnreadMessage = false
}

struct Person: Identifiable {
    let id = UUID()
    let name: String
    let imgString: String?
}

struct Message: Identifiable {
    
    enum MessageType {
        case sent, received
    }
    
    var id = UUID()
    var date: Date
    var text: String
    var type: MessageType
    
    init(_ text: String, type: MessageType, date: Date) {
        self.text = text
        self.type = type
        self.date = date
    }
    
    init(_ text: String, type: MessageType) {
        self.init(text, type: type, date: Date())
    }
}

extension Chat {
    
    static let sampleChats = [
        Chat(
            person: Person(
                name: "Daniel Moris",
                imgString: "daniel.moris"
            ),
            messages: [
                Message(
                    "Hi Daniel, my name is Eleni, I am a professional cleaner with 10 years of expirience. I can come to you tomorrow morning. 2 bedroom appartement costs 30 euros and takes about 3 hours. Is it okay for you?",
                    type: .sent,
                    date: Date(timeIntervalSinceNow: -86400 * 3)
                ),
                Message(
                    "I can also wash terrace, windows and balcony for extra 20 euros if needed.",
                    type: .sent,
                    date: Date(timeIntervalSinceNow: -86400 * 3)
                ),
                Message(
                    "Hi Eleni, sounds good for me, tomorrow morning is perfect.",
                    type: .received,
                    date: Date(timeIntervalSinceNow: -86400 * 3)
                ),
                Message(
                    "My plans have changed, so I’v changed the terms of order, could you reduce the cost please?",
                    type: .received,
                    date: Date(timeIntervalSinceNow: -86400 * 3)
                )
            ],
            hasUnreadMessage: false
        ),
        Chat(
            person: Person(
                name: "Robert Smith",
                imgString: nil
            ),
            messages: [
                Message(
                    "Hi Daniel, my name is Eleni, I am a professional cleaner with 10 years of expirience. I can come to you tomorrow morning. 2 bedroom appartement costs 30 euros and takes about 3 hours. Is it okay for you?",
                    type: .sent,
                    date: Date(timeIntervalSinceNow: -86400 * 3)
                ),
                Message(
                    "I can also wash terrace, windows and balcony for extra 20 euros if needed.",
                    type: .sent,
                    date: Date(timeIntervalSinceNow: -86400 * 3)
                ),
                Message(
                    "Hi Eleni, sounds good for me, tomorrow morning is perfect.",
                    type: .received,
                    date: Date(timeIntervalSinceNow: -86400 * 3)
                ),
                Message(
                    "My plans have changed, so I’v changed the terms of order, could you reduce the cost please?",
                    type: .received,
                    date: Date(timeIntervalSinceNow: -86400 * 3)
                )
            ],
            hasUnreadMessage: true
        )
    ]
}
