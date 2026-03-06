import Foundation

final class AIInsightService {
    func reply(to userText: String, snapshot: HourlyHealthSnapshot?) -> AIMessage {
        let context = snapshot.map { "当前健康分 \($0.score)。" } ?? ""
        let text = "我看到了你的状态。\(context)建议你先做一个 3 分钟恢复任务，再告诉我体感变化。"
        return AIMessage(timestamp: Date(), isFromAI: true, text: text)
    }

    func proactiveMessageIfNeeded(scoreHistory: [HourlyHealthSnapshot]) -> AIMessage? {
        let recent = scoreHistory.suffix(3)
        guard recent.count == 3, recent.allSatisfy({ $0.score < 60 }) else {
            return nil
        }

        return AIMessage(
            timestamp: Date(),
            isFromAI: true,
            text: "你已经连续 3 个小时处于高压力状态。现在先暂停 5 分钟，我可以带你做一次快速重置。"
        )
    }
}
