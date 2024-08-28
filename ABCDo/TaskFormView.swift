import SwiftUI

struct TaskFormView: View {
    @Binding var taskTitle: String
    @Binding var taskDescription: String
    @Binding var taskPriority: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("Title", text: $taskTitle)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)

            TextField("Description", text: $taskDescription)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)

            Stepper(value: $taskPriority, in: 1...5) {
                Text("Priority: \(taskPriority)")
            }
            .padding(.horizontal)
        }
    }
}
