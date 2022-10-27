import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ChatsViewModel()
    
    @State private var query = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.getSortedFiltredChats(query: query)) { chat in
                    ZStack {
                        ChatRow(chat: chat)
                        NavigationLink(destination: {
                            ChatView(chat: chat)
                                .environmentObject(viewModel)
                        }) {
                            EmptyView()
                        }
                        .buttonStyle(.plain)
                        .frame(width: 0)
                        .opacity(0)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button(action: {
                            viewModel.markAsUnread(!chat.hasUnreadMessage, chat: chat)
                        }) {
                            if chat.hasUnreadMessage {
                                Label("Read", systemImage: "text.bubble")
                            } else {
                                Label("Unread", systemImage: "circle.fill")
                            }
                        }
                        .tint(.blue)
                    }
                }
            }
            .listStyle(.plain)
            .searchable(text: $query)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {}) {
                Image(systemName: "ellipsis")
                    .tint(.black)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
