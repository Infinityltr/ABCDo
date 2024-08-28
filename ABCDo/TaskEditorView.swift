import SwiftUI

struct TaskEditorView: View {
    @Binding var task: Task
    @Binding var shouldSetReminder: Bool
    @Binding var reminderCount: Int
    @Binding var reminderIntervals: [Int]
    @Binding var reminderUnits: [String]

    @State private var shouldSetDate: Bool = true // 新增开关状态
    @State private var startDate: Date
    @State private var endDate: Date

    var onSave: () -> Void
    var onCancel: () -> Void

    init(task: Binding<Task>, shouldSetReminder: Binding<Bool>, reminderCount: Binding<Int>, reminderIntervals: Binding<[Int]>, reminderUnits: Binding<[String]>, onSave: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self._task = task
        self._shouldSetReminder = shouldSetReminder
        self._reminderCount = reminderCount
        self._reminderIntervals = reminderIntervals
        self._reminderUnits = reminderUnits
        self.onSave = onSave
        self.onCancel = onCancel
        
        // 初始化日期
        self._startDate = State(initialValue: task.wrappedValue.startDate)
        self._endDate = State(initialValue: task.wrappedValue.endDate)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TaskFormView(
                taskTitle: $task.title,
                taskDescription: Binding($task.description, default: ""), // 使用扩展进行绑定
                taskPriority: $task.priority
            )

            Toggle(isOn: $shouldSetDate) {
                Text("Set Date")
            }
            .padding(.horizontal)

            if shouldSetDate {
                DatePicker("Start Date", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                    .padding(.horizontal)

                DatePicker("End Date", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                    .padding(.horizontal)
                    .onChange(of: startDate) { oldValue, newValue in
                        // 自动更新endDate
                        if endDate < newValue {
                            endDate = newValue
                        }
                    }
            }

            ReminderSettingsView(shouldSetReminder: $shouldSetReminder, reminderCount: $reminderCount, reminderIntervals: $reminderIntervals, reminderUnits: $reminderUnits)

            HStack(spacing: 16) {
                Button(action: onSave) {
                    Text("Save")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity)
                }

                Button(action: onCancel) {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .onChange(of: startDate) { newStartDate in
            // 自动更新endDate
            if endDate < newStartDate {
                endDate = newStartDate
            }
        }
        .onAppear {
            // 同步初始化的startDate和endDate到任务
            task.startDate = startDate
            task.endDate = endDate
        }
    }
}

// Extension to provide a default value for optional bindings
extension Binding {
    init(_ source: Binding<Value?>, default defaultValue: Value) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { newValue in source.wrappedValue = newValue }
        )
    }
}
