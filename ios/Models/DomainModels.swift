import Foundation

enum AutonomicType: String, Codable, CaseIterable {
    case stressReactive = "压力高反应型"
    case slowRecovery = "恢复缓慢型"
    case circadianDisruption = "昼夜节律紊乱型"
    case balanced = "平衡型"
}

struct UserProfile: Codable {
    let id: UUID
    var ageRange: String
    var region: String
    var autonomicType: AutonomicType
    var baselineScore: Int
}

struct HRVSample: Identifiable {
    let id = UUID()
    let timestamp: Date
    let rmssd: Double
    let sdnn: Double
}

struct HourlyHealthSnapshot: Identifiable {
    let id = UUID()
    let timestamp: Date
    let hrvDeviation: Double
    let sleepDebt: Double
    let stressLoad: Double
    let behaviorLoad: Double
    let taskRecoveryBonus: Double

    var score: Int = 0
    var summary: String = ""
}

struct HealthTask: Identifiable {
    let id = UUID()
    let title: String
    let minutes: Int
    let trigger: String
    let expectedBenefit: String
}

struct LifestyleLog: Identifiable {
    let id = UUID()
    let timestamp: Date
    let mood: Int
    let stress: Int
    let caffeine: Bool
    let alcohol: Bool
    let cyclePhase: String
    let note: String
}

struct AIMessage: Identifiable {
    let id = UUID()
    let timestamp: Date
    let isFromAI: Bool
    let text: String
}
