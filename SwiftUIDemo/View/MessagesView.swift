import SwiftUI

struct MessagesView: View {
    
    let viewWidth: CGFloat
    let sectionMessages: [[Message]]
    let openEditing: (Message) -> ()
    
    var body: some View {
        LazyVGrid(
            columns: [GridItem(.flexible(minimum: 10))],
            spacing: 0
        ) {
            showOfferInfoView(viewWidth: viewWidth)
                        
            ForEach(sectionMessages.indices, id: \.self) { sectionIndex in
                let messages = sectionMessages[sectionIndex]
                
                Section(header: sectionHeader(firstMessage: messages.first!)) {
                    ForEach(messages) { message in
                        let isReceived = message.type == .received
                        messageContent(message: message, isReceived: isReceived, viewWidth: viewWidth)
                    }
                }
            }
        }
    }
    
    func messageContent(message: Message, isReceived: Bool, viewWidth: CGFloat) -> some View {
        HStack {
            ZStack {
                Text(message.text)
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(isReceived ? .black.opacity(0.1) : .blue.opacity(0.1))
                    .cornerRadius(10)
            }
            .contextMenu {
                Button(action: {}) {
                    Label("Save as a template", image: "noteAdd")
                }
                Button(action: {}) {
                    Label("Copy", image: "copy")
                }
                
                if !isReceived {
                    Button(action: { openEditing(message) }) {
                        Label("Edit", image: "editPen")
                    }
                    Button(action: {}) {
                        Label("Delete", image: "trashCan")
                    }
                }
            }
            .frame(width: viewWidth * 0.7, alignment: isReceived ? .leading : .trailing)
            .padding(.vertical)
        }
        .frame(maxWidth: .infinity, alignment: isReceived ? .leading : .trailing)
        .id(message.id)
    }
    
    func showOfferInfoView(viewWidth: CGFloat) -> some View {
        VStack {
            VStack(alignment: .center, spacing: 12) {
                Image("coin")
                    .resizable()
                    .frame(width: 50, height: 50)
                Text("Daniel gets your offer for")
                    .font(.system(size: 14, weight: .regular))
                Text("€1 498,00")
                    .font(.system(size: 18, weight: .semibold))
            }
            .padding(.top, 20)
            
            Divider()
            
            Text("To complete the deal, Daniel must accept your offer, until that you can discuss the details here")
                .font(.system(size: 12, weight: .regular))
                .multilineTextAlignment(.center)
        }
        .frame(width: viewWidth * 0.925, height: 215)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray, lineWidth: 1)
                .opacity(0.5)
        )
    }
    
    func sectionHeader(firstMessage message: Message) -> some View {
        ZStack {
            Text(message.date.descriptiveString(style: .medium))
                .foregroundColor(.gray)
                .font(.system(size: 12, weight: .regular))
        }
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity)
    }
    
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView(
            viewWidth: 375,
            sectionMessages: [[
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
        ]]) { _ in
            
        }
    }
}
