//
//  Untitled.swift
//  demo
//
//  Created by 陆朦 on 2025/6/20.
//


import FoundationModels
import Foundation

@available(iOS 26.0, *)
struct ChatMessage: Identifiable {
    /// 消息生成的唯一id
    var id: GenerationID
    
    /// 消息内容
    var content: String
    
    /// 是否是用户消息，用于区分是人生成的还是ai
    var isUser: Bool
    
    /// 消息时间戳
    var timestamp: Date
    
    // 标准初始化方法
    init(id: GenerationID = GenerationID(),
         content: String,
         isUser: Bool,
         timestamp: Date = Date()) {
        self.id = id
        self.content = content
        self.isUser = isUser
        self.timestamp = timestamp
    }
}

// 便利方法扩展
@available(iOS 26.0, *)
extension ChatMessage {
    // 创建用户消息
    static func userMessage(_ content: String) -> ChatMessage {
        ChatMessage(content: content, isUser: true)
    }
    
    // 创建 AI 消息
    static func aiMessage(_ content: String) -> ChatMessage {
        ChatMessage(content: content, isUser: false)
    }
    
    // 格式化时间
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
}
