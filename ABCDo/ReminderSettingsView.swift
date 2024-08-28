import SwiftUI

struct ReminderSettingsView: View {
    @Binding var shouldSetReminder: Bool
    @Binding var reminderCount: Int
    @Binding var reminderIntervals: [Int]
    @Binding var reminderUnits: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Toggle(isOn: $shouldSetReminder) {
                Text("Set Reminder")
            }
            .padding(.horizontal)

            if shouldSetReminder {
                Stepper("Number of Reminders: \(reminderCount)", value: $reminderCount, in: 1...5, onEditingChanged: { _ in
                    adjustRemindersArraySize()
                })
                .padding(.horizontal)
                
                ForEach(0..<reminderCount, id: \.self) { index in
                    HStack {
                        TextField("Interval", value: $reminderIntervals[index], formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        
                        Picker("Unit", selection: $reminderUnits[index]) {
                            Text("Minutes").tag("minutes")
                            Text("Hours").tag("hours")
                            Text("Days").tag("days")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 120)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }

    private func adjustRemindersArraySize() {
        // 扩展或缩小 reminderIntervals 和 reminderUnits 数组的大小，以匹配 reminderCount
        while reminderIntervals.count < reminderCount {
            reminderIntervals.append(0) // 添加默认值
        }
        while reminderUnits.count < reminderCount {
            reminderUnits.append("minutes") // 添加默认值
        }
        
        // 确保数组的大小不超过 reminderCount
        if reminderIntervals.count > reminderCount {
            reminderIntervals.removeLast(reminderIntervals.count - reminderCount)
        }
        if reminderUnits.count > reminderCount {
            reminderUnits.removeLast(reminderUnits.count - reminderCount)
        }
    }
}
