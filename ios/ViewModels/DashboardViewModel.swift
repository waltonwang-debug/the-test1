import Foundation
import Combine

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var latestSnapshot: HourlyHealthSnapshot?
    @Published var recommendations: [HealthTask] = []
    @Published var messages: [AIMessage] = []

    private(set) var history: [HourlyHealthSnapshot] = []

    private let healthDataService: HealthDataService
    private let scoringEngine: ScoringEngine
    private let taskEngine: TaskRecommendationEngine
    private let aiService: AIInsightService

    init(
        healthDataService: HealthDataService,
        scoringEngine: ScoringEngine,
        taskEngine: TaskRecommendationEngine,
        aiService: AIInsightService
    ) {
        self.healthDataService = healthDataService
        self.scoringEngine = scoringEngine
        self.taskEngine = taskEngine
        self.aiService = aiService
    }



    convenience init() {
        self.init(
            healthDataService: MockHealthDataService(),
            scoringEngine: ScoringEngine(),
            taskEngine: TaskRecommendationEngine(),
            aiService: AIInsightService()
        )
    }

    func bootstrap() async {
        _ = await healthDataService.requestPermissions()
        await refreshHourlyAssessment()
    }

    func refreshHourlyAssessment() async {
        let snapshot = await healthDataService.fetchLatestHourlySnapshot()
        let evaluated = scoringEngine.evaluate(snapshot: snapshot)

        latestSnapshot = evaluated
        history.append(evaluated)
        recommendations = taskEngine.recommend(for: evaluated)

        if let proactive = aiService.proactiveMessageIfNeeded(scoreHistory: history) {
            messages.append(proactive)
        }
    }

    func askAI(_ text: String) {
        messages.append(AIMessage(timestamp: Date(), isFromAI: false, text: text))
        messages.append(aiService.reply(to: text, snapshot: latestSnapshot))
    }
}
