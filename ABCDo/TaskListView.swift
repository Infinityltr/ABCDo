import SwiftUI

struct TaskListView: View {
    @Binding var tasks: [Task]
    @Binding var isEditing: Bool
    @State private var expandedTaskID: UUID? // 用于跟踪当前展开的任务
    @State private var selectedTasks = Set<UUID>() // 跟踪选中的任务

    var onEdit: (Task) -> Void
    var onDelete: ([Task]) -> Void

    var body: some View {
        VStack {
            if tasks.isEmpty {
                Text("No tasks available")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(tasks.indices, id: \.self) { index in
                        taskRow(task: $tasks[index])
                    }
                }
                .navigationBarItems(
                    leading: isEditing ? selectAllButton : nil,
                    trailing: isEditing ? deleteButton : nil
                )
            }
        }
    }
    
    private func taskRow(task: Binding<Task>) -> some View {
        VStack(alignment: .leading) {
            HStack {
                if isEditing {
                    Button(action: {
                        if selectedTasks.contains(task.wrappedValue.id) {
                            selectedTasks.remove(task.wrappedValue.id)
                        } else {
                            selectedTasks.insert(task.wrappedValue.id)
                        }
                    }) {
                        Image(systemName: selectedTasks.contains(task.wrappedValue.id) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(selectedTasks.contains(task.wrappedValue.id) ? .blue : .gray)
                            .imageScale(.large)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }

                Text(task.wrappedValue.title)
                    .font(.headline)

                Spacer()

                Text("Priority: \(task.wrappedValue.priority)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(task.wrappedValue.startDate, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Button(action: {
                    withAnimation {
                        toggleExpansion(for: task.wrappedValue)
                    }
                }) {
                    Image(systemName: "info.circle")
                        .imageScale(.large)
                }
            }

            if expandedTaskID == task.wrappedValue.id {
                taskDetails(task: task.wrappedValue)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func taskDetails(task: Task) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description: \(task.description ?? "No description")")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("End Date: \(task.endDate, style: .date)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("Reminder: \(task.reminders.isEmpty ? "No reminders set" : "\(task.reminders.count) reminders")")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 8)
    }
    
    private var selectAllButton: some View {
        Button("Select All") {
            selectedTasks = Set(tasks.map { $0.id })
        }
    }
    
    private var deleteButton: some View {
        Button("Delete") {
            onDelete(Array(selectedTasks.compactMap { id in tasks.first(where: { $0.id == id }) }))
            selectedTasks.removeAll()
        }
    }
    
    private func toggleExpansion(for task: Task) {
        if expandedTaskID == task.id {
            expandedTaskID = nil // 如果已经展开，则折叠
        } else {
            expandedTaskID = task.id // 展开当前任务
        }
    }
}
