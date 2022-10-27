import SwiftUI
import UIKit

struct MessageTextField: View {
    
    let placeholder: String
    @Binding var text: String
    @Binding var isEditing: Bool
    @State private var height: CGFloat = 40

    var body: some View {
        ZStack {
            UITextViewWrapper(
                text: $text,
                isEditing: $isEditing,
                height: $height
            )
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(.black)
            .padding(.leading, 12)
            .padding(.trailing, 40)
            
            Button(action: {}) {
                Image("addImage")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 14)
            }
        }
        .frame(height: height)
        .background(placeholderView, alignment: .leading)
        .background(.thinMaterial)
        .cornerRadius(20)
    }
    
    var placeholderView: some View {
        Group {
            if text.isEmpty {
                Text(placeholder)
                    .frame(height: 20)
                    .foregroundColor(.secondary)
                    .font(.system(size: 14, weight: .regular))
                    .padding(.leading, 16)
            }
        }
    }
}

private struct UITextViewWrapper: UIViewRepresentable {
    
    @Binding var text: String
    @Binding var isEditing: Bool
    @Binding var height: CGFloat
    
    private let maxHeight: CGFloat = 118
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.delegate = context.coordinator
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.backgroundColor = .clear
        view.isEditable = true
        view.isSelectable = true
        view.isUserInteractionEnabled = true
        view.isScrollEnabled = true
        view.textColor = .label
        view.tintColor = .label
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        calculateHeight(uiView)
    }
    
    func calculateHeight(_ view: UIView) {
        let size = view.sizeThatFits(
            CGSize(
                width: view.frame.size.width,
                height: .greatestFiniteMagnitude
            )
        )
        guard height != size.height else { return }
        DispatchQueue.main.async {
            height = min(size.height, maxHeight)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

final class Coordinator: NSObject, UITextViewDelegate {
    
    fileprivate let parent: UITextViewWrapper
    
    fileprivate init(parent: UITextViewWrapper) {
        self.parent = parent
    }
    
    func textViewDidChange(_ textView: UITextView) {
        parent.text = textView.text
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !textView.text.isEmpty {
            parent.isEditing = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        parent.isEditing = false
    }
}

struct MessageTextField_Previews: PreviewProvider {
    static var previews: some View {
        MessageTextField(placeholder: "Message...", text: .constant(""), isEditing: .constant(false))
    }
}
