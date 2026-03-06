import Foundation

final class ScoringEngine {
    /// score = 100 - A*hrvDrop - B*sleepDebt - C*stress - D*behavior + E*taskBonus
    func evaluate(snapshot: HourlyHealthSnapshot) -> HourlyHealthSnapshot {
        let hrvPenalty = max(0, -snapshot.hrvDeviation) * 20
        let sleepPenalty = snapshot.sleepDebt * 18
        let stressPenalty = snapshot.stressLoad * 22
        let behaviorPenalty = snapshot.behaviorLoad * 16
        let bonus = snapshot.taskRecoveryBonus * 14

        let raw = 100 - hrvPenalty - sleepPenalty - stressPenalty - behaviorPenalty + bonus
        let bounded = Int(max(0, min(100, raw)).rounded())

        var result = snapshot
        result.score = bounded
        result.summary = summary(for: result)
        return result
    }

    private func summary(for snapshot: HourlyHealthSnapshot) -> String {
        switch snapshot.score {
        case 80...100:
            return "状态稳定，建议保持节奏并继续轻量恢复习惯。"
        case 60..<80:
            return "轻度压力激活，建议执行 2-6 分钟呼吸或步行任务。"
        default:
            return "交感神经可能持续兴奋，优先做降负荷任务并减少刺激。"
        }
    }
}
