import Foundation

protocol HealthDataService {
    func fetchLatestHourlySnapshot() async -> HourlyHealthSnapshot
    func requestPermissions() async -> Bool
}

final class MockHealthDataService: HealthDataService {
    func requestPermissions() async -> Bool {
        true
    }

    func fetchLatestHourlySnapshot() async -> HourlyHealthSnapshot {
        HourlyHealthSnapshot(
            timestamp: Date(),
            hrvDeviation: Double.random(in: -1.5...1.2),
            sleepDebt: Double.random(in: 0...1),
            stressLoad: Double.random(in: 0...1),
            behaviorLoad: Double.random(in: 0...1),
            taskRecoveryBonus: Double.random(in: 0...0.4)
        )
    }
}
