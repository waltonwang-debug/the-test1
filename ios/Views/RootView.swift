import SwiftUI

struct RootView: View {
    @EnvironmentObject var container: AppContainer
    @StateObject private var viewModel = DashboardViewModel()

    @State private var isOnboardingCompleted = false
    @State private var onboardingStep = 0

    @State private var sleepQuality = 3
    @State private var stressLevel = 3
    @State private var caffeineFrequency = 2
    @State private var exerciseFrequency = 3
    @State private var circadianRegularity = 3

    var body: some View {
        NavigationStack {
            if isOnboardingCompleted {
                dashboardView
            } else {
                onboardingView
            }
        }
        .task {
            await viewModel.bootstrap()
        }
    }

    private var dashboardView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                safetyCard
                profileSummaryCard
                scoreCard
                taskCard
                aiCard
                logCard
            }
            .padding()
        }
        .navigationTitle("Autonomic Coach")
    }

    private var onboardingView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("欢迎使用 Autonomic Coach")
                    .font(.title.bold())
                Text("先完成 onboarding，我们会用问卷初始化你的自主神经画像。")
                    .foregroundStyle(.secondary)

                ProgressView(value: Double(onboardingStep + 1), total: 3)

                Group {
                    if onboardingStep == 0 {
                        introCard
                    } else if onboardingStep == 1 {
                        questionnaireCard
                    } else {
                        resultCard
                    }
                }

                HStack {
                    if onboardingStep > 0 {
                        Button("上一步") { onboardingStep -= 1 }
                            .buttonStyle(.bordered)
                    }
                    Spacer()
                    if onboardingStep < 2 {
                        Button("下一步") { onboardingStep += 1 }
                            .buttonStyle(.borderedProminent)
                    } else {
                        Button("进入主页") {
                            completeOnboarding()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Onboarding")
    }

    private var introCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Onboarding 第一步")
                .font(.headline)
            Text("我们会结合问卷和后续可穿戴数据（HRV 为主）给你每小时健康分与建议。")
            Text("免责声明：本应用用于健康管理，不提供医疗诊断。")
                .font(.caption)
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
            stepperRow("睡眠质量", value: $sleepQuality)
            stepperRow("压力水平", value: $stressLevel)
            stepperRow("咖啡因频率", value: $caffeineFrequency)
            stepperRow("运动频率", value: $exerciseFrequency)
            stepperRow("昼夜规律", value: $circadianRegularity)
            Button("生成自主神经类型") {
                generateProfileFromQuestionnaire()
                onboardingStep = 2
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var resultCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("评估结果")
                .font(.headline)
            if let profile = container.currentProfile {
                Text("类型：\(profile.autonomicType.rawValue)")
                Text("基线分：\(profile.baselineScore)")
                Text("下一步：进入主页后，每小时会自动更新健康分和任务建议。")
                    .foregroundStyle(.secondary)
            } else {
                Text("请先返回上一步生成类型。")
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func stepperRow(_ title: String, value: Binding<Int>) -> some View {
        HStack {
            Text(title)
            Spacer()
            Stepper("\(value.wrappedValue)", value: value, in: 1...5)
                .labelsHidden()
            Text("\(value.wrappedValue)")
                .monospacedDigit()
                .frame(width: 20)
        }
    }

    private func generateProfileFromQuestionnaire() {
        let answer = QuestionnaireAnswer(
            sleepQuality: sleepQuality,
            stressLevel: stressLevel,
            caffeineFrequency: caffeineFrequency,
            exerciseFrequency: exerciseFrequency,
            circadianRegularity: circadianRegularity
        )
        container.currentProfile = container.questionnaireEngine.evaluate(answer)
    }

    private func completeOnboarding() {
        if container.currentProfile == nil {
            generateProfileFromQuestionnaire()
        }
        isOnboardingCompleted = true
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

    private var profileSummaryCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("你的画像")
                .font(.headline)
            if let profile = container.currentProfile {
                Text("类型：\(profile.autonomicType.rawValue)｜基线分：\(profile.baselineScore)")
                    .font(.subheadline)
            } else {
                Text("尚未完成画像")
                    .foregroundStyle(.secondary)
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
