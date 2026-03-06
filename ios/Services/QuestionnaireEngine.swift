import Foundation

struct QuestionnaireAnswer {
    let sleepQuality: Int
    let stressLevel: Int
    let caffeineFrequency: Int
    let exerciseFrequency: Int
    let circadianRegularity: Int
}

final class QuestionnaireEngine {
    func evaluate(_ answer: QuestionnaireAnswer) -> UserProfile {
        let stressScore = answer.stressLevel + answer.caffeineFrequency
        let recoveryScore = (6 - answer.sleepQuality) + (6 - answer.exerciseFrequency)
        let circadianScore = 6 - answer.circadianRegularity

        let autonomicType: AutonomicType
        if stressScore >= max(recoveryScore, circadianScore) {
            autonomicType = .stressReactive
        } else if recoveryScore >= circadianScore {
            autonomicType = .slowRecovery
        } else {
            autonomicType = .circadianDisruption
        }

        let baseline = max(45, 80 - stressScore * 3 - recoveryScore * 2 - circadianScore * 2)
        return UserProfile(
            id: UUID(),
            ageRange: "25-35",
            region: "US",
            autonomicType: autonomicType,
            baselineScore: baseline
        )
    }
}
