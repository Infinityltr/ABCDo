import SwiftUI

struct ContentView: View {
    @State private var tasks: [Task] = []
    @State private var selectedTask: Task? = nil
    @State private var showingEditor = false
    @State private var isNewTask = false
    @State private var isEditing = false // 新增状态

    @State private var shouldSetReminder = false
    @State private var reminderCount: Int = 1
    @State private var reminderIntervals: [Int] = [0]
    @State private var reminderUnits: [String] = ["minutes"]

    @State private var showingSettings = false
    @State private var selectedLanguage = "English"

    var notificationManager = NotificationManager()
    var dataStorageManager = DataStorageManager.shared
    var clipboardManager = ClipboardManager()

    var body: some View {
        NavigationView {
            VStack {
                TaskListView(tasks: $tasks, isEditing: $isEditing, onEdit: { task in
                    selectedTask = task
                    isNewTask = false
                    showingEditor = true
                }, onDelete: { tasksToDelete in
                    tasks.removeAll { task in
                        tasksToDelete.contains(where: { $0.id == task.id })
                    }
                })

                HStack {
                    Button(action: {
                        if let taskComponents = clipboardManager.processClipboard() {
                            selectedTask = Task(title: taskComponents.title, description: "", startDate: taskComponents.startDate ?? Date(), endDate: taskComponents.endDate ?? Date().addingTimeInterval(3600), priority: 1)
                            isNewTask = true
                            showingEditor = true
                        }
                    }) {
                        Text("Add from Clipboard")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        // 创建新任务并打开编辑器
                        selectedTask = Task(title: "", description: "", startDate: Date(), endDate: Date().addingTimeInterval(3600), priority: 1)
                        isNewTask = true
                        showingEditor = true
                    }) {
                        Text("Add Task")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())

                }
                .padding(.top, 10)
            }
            .navigationBarItems(leading: Button(action: {
                isEditing.toggle() // 点击按钮切换编辑模式
            }) {
                Text(isEditing ? "Done" : "Select")
                    .foregroundColor(isEditing ? .blue : .primary)
            },
            trailing: Button(action: {
                showingSettings = true
            }) {
                Image(systemName: "gear")
                    .imageScale(.large)
                    .padding()
            })
            .sheet(isPresented: $showingEditor) {
                TaskEditorView(
                    task: Binding($selectedTask, default: Task(title: "", description: "", startDate: Date(), endDate: Date().addingTimeInterval(3600), priority: 1)),
                    shouldSetReminder: $shouldSetReminder,
                    reminderCount: $reminderCount,
                    reminderIntervals: $reminderIntervals,
                    reminderUnits: $reminderUnits,
                    onSave: {
                        if isNewTask {
                            tasks.append(selectedTask!)
                        } else {
                            if let index = tasks.firstIndex(where: { $0.id == selectedTask!.id }) {
                                tasks[index] = selectedTask!
                            }
                        }
                        dataStorageManager.saveTask(selectedTask!)
                        showingEditor = false
                    },
                    onCancel: {
                        selectedTask = nil
                        showingEditor = false
                    }
                )
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(selectedLanguage: $selectedLanguage)
            }
            .onAppear {
                tasks = dataStorageManager.loadTasks()
            }
        }
    }
}
