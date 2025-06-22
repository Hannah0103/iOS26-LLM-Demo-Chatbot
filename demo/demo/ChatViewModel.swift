//
//  ChatViewModel.swift
//  demo
//
//  Created by 陆朦 on 2025/6/20.
//


import FoundationModels
import Observation
import Foundation


@available(iOS 26.0, *)

class ChatViewModel: ObservableObject {
    private var session: LanguageModelSession
       @Published private(set) var messages: [ChatMessage] = []
       @Published var inputText: String = ""
       @Published var isProcessing = false
    
    init() {
        let instructions = "AI助手，可以帮助用户解答问题。"
        
        // 初始化语言模型会话，使用默认模型
        self.session = LanguageModelSession(
            model: .default,
            instructions: instructions
        )
    }
        
    @MainActor
    func sendMessage() async throws {
        guard !inputText.isEmpty else { return }
     
        let userInputText = inputText
        
        inputText = ""
        
        isProcessing = true
        defer { isProcessing = false }
        
        // 添加用户消息
        let userMessage = ChatMessage(
            id: GenerationID(),
            content: userInputText,
            isUser: true,
            timestamp: Date()
        )
        messages.append(userMessage)
        
        // 设置生成选项
        let options = GenerationOptions(
            // temperature 控制输出的随机性：
            // - 范围：0.0 到 1.0
            // - 0.0：输出非常确定，适合需要准确的场景
            // - 0.7：平衡值，既保持一定的创造性，又不会太过随机，是大多数对话场景的推荐值
            // - 1.0：最大随机性，输出更有创意但可能不够连贯
            temperature: 0.7,
            
            // maximumResponseTokens 控制回复的最大长度：
            // - 一个 token 大约等于 4 个字符
            // - 1000 tokens 大约等于 500-800 个汉字
            // - 设置为 1000 是为了：
            //   1. 确保回复够详细（不会过早截断）
            //   2. 又不会生成过长的内容影响对话体验
            //   3. 控制资源消耗（tokens 越多，处理时间越长）
            maximumResponseTokens: 1000
        )
        
        do {
            // 获取模型响应
            let response = try await session.respond(
                to: userInputText,
                options: options
            )
            
            // 创建并添加 AI 响应消息
            let assistantMessage = ChatMessage(
                id: GenerationID(),
                content: response.content,
                isUser: false,
                timestamp: Date()
            )
            messages.append(assistantMessage)
        } catch {
           let errorMessage = ChatMessage(
               id: GenerationID(),
               content: """
               模型输出错误，详细错误信息：
               \(String(describing: error))
               """,
               isUser: false,
               timestamp: Date()
           )
           messages.append(errorMessage)
        }
    }
}

