//
//  ChatView.swift
//  demo
//
//  Created by 陆朦 on 2025/6/20.
//


import SwiftUI


@available(iOS 26.0, *)
struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
       
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.messages) { message in
                        MessageBubble(message: message)
                    }
                    
                    // 添加 loading 动效
                    if viewModel.isProcessing {
                        LoadingBubble()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                }
            }
            
            HStack {
                TextField("输入消息...", text: $viewModel.inputText)
                    .textFieldStyle(.roundedBorder)
                    .disabled(viewModel.isProcessing)
                
                Button(action: {
                    Task {
                        try? await viewModel.sendMessage()
                    }
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                }
                .disabled(viewModel.inputText.isEmpty || viewModel.isProcessing)
            }
            .padding()
        }
        .navigationTitle("AI 对话")
    }
}

@available(iOS 26.0, *)
struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            Text(message.content)
                .padding()
                .background(message.isUser ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(message.isUser ? .white : .primary)
                .cornerRadius(16)
            
            if !message.isUser {
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

// 添加 LoadingBubble 组件
struct LoadingBubble: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 8, height: 8)
                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                    .animation(
                        Animation.easeInOut(duration: 0.5)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: isAnimating
                    )
            }
        }
        .padding(12)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(16)
        .onAppear {
            isAnimating = true
        }
    }
}
