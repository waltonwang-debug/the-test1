import SwiftUI

struct RootView: View {
    @EnvironmentObject var container: AppContainer
    @StateObject private var viewModel = DashboardViewModel()
    @State private var questionAnswer = QuestionnaireAnswer(
        sleepQuality: 3,
        stressLevel: 3,
        caffeineFrequency: 2,
        exerciseFrequency: 3,
        circadianRegularity: 3
    )

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    safetyCard
                    questionnaireCard
                    scoreCard
                    taskCard
                    aiCard
                    logCard
                }
                .padding()
            }
            .navigationTitle("Autonomic Coach")
            .task {
                await viewModel.bootstrap()
            }
        }
    }

    private var safetyCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("使用说明")
                .font(.headline)
            Text("本应用用于健康管理与生活方式建议，不提供医疗诊断。若出现持续胸闷、惊恐或严重失眠，请及时联系医生。")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var questionnaireCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("问卷评估")
                .font(.headline)
            Text("通过问卷完成自主神经类型初始化。")
            Button("生成类型") {
                container.currentProfile = container.questionnaireEngine.evaluate(questionAnswer)
            }
            if let profile = container.currentProfile {
                Text("类型：\(profile.autonomicType.rawValue)｜基线分：\(profile.baselineScore)")
                    .font(.subheadline)
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var scoreCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("每小时健康分")
                .font(.headline)
            if let snapshot = viewModel.latestSnapshot {
                Text("当前分数：\(snapshot.score)")
                    .font(.title2.bold())
                Text(snapshot.summary)
                Divider()
                Text("分数依据")
                    .font(.subheadline.bold())
                Text("HRV偏移：\(snapshot.hrvDeviation, specifier: "%.2f")  睡眠负债：\(snapshot.sleepDebt, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("压力负荷：\(snapshot.stressLoad, specifier: "%.2f")  行为负荷：\(snapshot.behaviorLoad, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Text("等待数据中...")
            }
            Button("立即刷新") {
                Task { await viewModel.refreshHourlyAssessment() }
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var taskCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("可执行小任务")
                .font(.headline)
            if viewModel.recommendations.isEmpty {
                Text("暂无任务，请先刷新健康分。")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            ForEach(viewModel.recommendations) { task in
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title).bold()
                    Text("\(task.minutes) 分钟 · \(task.expectedBenefit)")
                        .font(.subheadline)
                    Text("触发场景：\(task.trigger)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var aiCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("专家 AI")
                .font(.headline)
            Button("问 AI：我现在该做什么？") {
                viewModel.askAI("我现在该做什么？")
            }
            if viewModel.messages.isEmpty {
                Text("你可以随时向 AI 提问睡眠、压力和恢复节奏。")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            ForEach(viewModel.messages.suffix(3)) { message in
                Text("\(message.isFromAI ? "AI" : "我")：\(message.text)")
                    .font(.subheadline)
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var logCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("快速 Log")
                .font(.headline)
            Button("记录：压力4/5 + 咖啡因") {
                container.logStore.add(
                    mood: 3,
                    stress: 4,
                    caffeine: true,
                    alcohol: false,
                    cyclePhase: "luteal",
                    note: "下午连会"
                )
            }
            if let latest = container.logStore.logs.first {
                Text("最新：压力\(latest.stress)/5，备注：\(latest.note)")
                    .font(.subheadline)
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
