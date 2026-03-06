import Foundation
import Combine

final class LogStore: ObservableObject {
    @Published private(set) var logs: [LifestyleLog] = []

    func add(
        mood: Int,
        stress: Int,
        caffeine: Bool,
        alcohol: Bool,
        cyclePhase: String,
        note: String
    ) {
        logs.insert(
            LifestyleLog(
                timestamp: Date(),
                mood: mood,
                stress: stress,
                caffeine: caffeine,
                alcohol: alcohol,
                cyclePhase: cyclePhase,
                note: note
            ),
            at: 0
        )
    }
}
