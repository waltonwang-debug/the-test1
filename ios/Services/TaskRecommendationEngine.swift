import Foundation

final class TaskRecommendationEngine {
    func recommend(for snapshot: HourlyHealthSnapshot) -> [HealthTask] {
        if snapshot.score < 60 {
            return [
                HealthTask(
                    title: "3分钟延长呼气呼吸",
                    minutes: 3,
                    trigger: "高压时段",
                    expectedBenefit: "降低交感兴奋，帮助心率和呼吸节奏回稳"
                ),
                HealthTask(
                    title: "离开屏幕快走6分钟",
                    minutes: 6,
                    trigger: "久坐后",
                    expectedBenefit: "缓解精神疲劳，改善短时 HRV 趋势"
                )
            ]
        }

        return [
            HealthTask(
                title: "2分钟躯体扫描",
                minutes: 2,
                trigger: "每小时提醒",
                expectedBenefit: "提高觉察，预防压力累积"
            )
        ]
    }
}
