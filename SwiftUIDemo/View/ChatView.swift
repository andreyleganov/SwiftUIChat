import SwiftUI

struct ChatView: View {
    
    @State var navigationBarBackButtonHidden = true
    
    @EnvironmentObject var viewModel: ChatsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let chat: Chat
    
    @State private var text = ""
    @State private var isEditing = false
    @State private var editingOpened = false
    @State private var editingMessage = Message("", type: .sent)
    @FocusState private var isFocused
    
    @State private var messageIdToScroll: UUID?
    
    var body: some View {
        VStack {
            showOfferInfoHeader()
            
            GeometryReader { reader in
                
                ScrollView {
                    ScrollViewReader { scrollReader in
                        getMessagesView(viewWidth: reader.size.width)
                            .padding(.horizontal)
                            .onChange(of: messageIdToScroll) { _ in
                                if let messageId = messageIdToScroll {
                                    scrollTo(
                                        messageId: messageId,
                                        shouldAnimate: true,
                                        scrollReader: scrollReader
                                    )
                                }
                            }
                            .onAppear {
                                if let messageId = chat.messages.last?.id {
                                    scrollTo(
                                        messageId: messageId,
                                        anchor: .bottom,
                                        shouldAnimate: true,
                                        scrollReader: scrollReader
                                    )
                                }
                            }
                    }
                }
            }
            toolBarView()
        }
        .navigationBarHidden(true)
        .padding(.top, 48)
        .overlay(content: {
            VStack(spacing: 14) {
                ZStack(alignment: .leading) {
                    navBarLeadingItem
                        .padding(.leading, 14)
                    navBarTrailingItem
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 18)
                }
                Divider()
            }
            .frame(maxHeight: .infinity, alignment: .top)
        })
        .onAppear {
            viewModel.markAsUnread(false, chat: chat)
        }
    }
    
    var navBarLeadingItem: some View {
        HStack(spacing: 10) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("navBackButton")
            }
            .frame(width: 28, height: 28)
            
            if let image = chat.person.imgString {
                Image(image)
                    .cornerRadius(17)
                    .frame(width: 34, height: 34)
            }
            else {
                Image(systemName: "person.fill")
                    .tint(.black)
            }
            VStack(alignment: .leading, spacing: 0) {
                Text(chat.person.name)
                    .font(.system(size: 14, weight: .semibold))
                HStack(spacing: 6) {
                    Image("verify")
                        .frame(width: 16, height: 16, alignment: .leading)
                    Text("Verified")
                        .font(.system(size: 12, weight: .regular))
                }
            }
        }
    }
    
    var navBarTrailingItem: some View {
        Button(action: {}) {
            Image("dots")
                .resizable()
                .frame(width: 32, height: 32)
        }
    }
    
    func scrollTo(
        messageId: UUID,
        anchor: UnitPoint? = nil,
        shouldAnimate: Bool,
        scrollReader: ScrollViewProxy) {
            DispatchQueue.main.async {
                withAnimation(shouldAnimate ? .easeIn : nil) {
                    scrollReader.scrollTo(messageId, anchor: anchor)
                }
            }
    }
    
    func toolBarView() -> some View {
        VStack {
            Divider()
            
            if editingOpened {
                VStack {
                    ZStack {
                        HStack {
                            Image("editPen")
                                .frame(width: 16, height: 16)
                            Text("Edit message")
                                .font(.system(size: 12))
                        }
                        .opacity(0.5)
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Button(action: cancelEditing ) {
                            Image("crossCircle")
                                .frame(width: 24, height: 24)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    Text(editingMessage.text)
                        .lineLimit(1)
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 64)
                }
                .padding(.leading, 14)
                .padding(.trailing, 14)
            }
            
            ZStack {
                MessageTextField(
                    placeholder: "Message...",
                    text: $text,
                    isEditing: $isEditing
                )
                .onChange(of: text, perform: { newValue in
                    if !newValue.isEmpty {
                        text = newValue
                        isEditing = true
                        if editingOpened {
                            editingMessage.text = newValue
                        }
                    } else {
                        isEditing = false
                    }
                })
                .padding(.vertical, 14)
                .padding(.leading, 14)
                .padding(.trailing, isEditing ? 64 : 14)
                .focused($isFocused)
                
                if isEditing {
                    Button(action: { sendMessage(editable: editingOpened) }) {
                        Image("sendButton")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 14)
                    .padding(.bottom, 6)
                    .disabled(text.isEmpty)
                }
            }
            .background(.clear)
        }
        .background(.clear)
    }
    
    func sendMessage(editable: Bool) {
        guard !text.isEmpty else { return }
        
        guard !editingOpened else {
            if let message = viewModel.editMessage(editingMessage, in: chat) {
                text = ""
                editingOpened = false
                messageIdToScroll = message.id
            }
            return
        }
        
        if let message = viewModel.sendMessage(text, in: chat) {
            text = ""
            messageIdToScroll = message.id
        }
    }
    
    func openEditing(_ currentMessage: Message) {
        text = currentMessage.text
        editingMessage = currentMessage
        editingOpened = true
    }
    
    func cancelEditing() {
        text = ""
        isEditing = false
        editingOpened = false
    }
    
    func showOfferInfoHeader() -> some View {
        VStack {
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Cleaning of a two-room apartment")
                        .font(.system(size: 12, weight: .regular))
                    Text("€1 498,00")
                        .font(.system(size: 14, weight: .semibold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 14)
                
                Button(action: {}) {
                    Text("Change offer")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.black, lineWidth: 1)
                        )
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 14)
            }
            .padding(.top, 14)
            
            Divider()
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .frame(height: 61)
    }
    
    func getMessagesView(viewWidth: CGFloat) -> some View {
        MessagesView(
            viewWidth: viewWidth,
            sectionMessages: viewModel.getSectionMessages(for: chat)) { message in
                openEditing(message)
            }
    }
    
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView(chat: Chat.sampleChats[0])
                .environmentObject(ChatsViewModel())
        }
    }
}
