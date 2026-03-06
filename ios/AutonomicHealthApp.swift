import SwiftUI

@main
struct AutonomicHealthApp: App {
    @StateObject private var container = AppContainer()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(container)
        }
    }
}

final class AppContainer: ObservableObject {
    let healthDataService: HealthDataService
    let questionnaireEngine: QuestionnaireEngine
    let scoringEngine: ScoringEngine
    let taskEngine: TaskRecommendationEngine
    let aiInsightService: AIInsightService
    let logStore: LogStore

    @Published var currentProfile: UserProfile?

    init() {
        self.healthDataService = MockHealthDataService()
        self.questionnaireEngine = QuestionnaireEngine()
        self.scoringEngine = ScoringEngine()
        self.taskEngine = TaskRecommendationEngine()
        self.aiInsightService = AIInsightService()
        self.logStore = LogStore()
    }
}
