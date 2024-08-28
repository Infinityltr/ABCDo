import SwiftUI

struct SettingsView: View {
    @Binding var selectedLanguage: String

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Language")) {
                    Picker("Select Language", selection: $selectedLanguage) {
                        Text("English").tag("English")
                        Text("Chinese").tag("Chinese")
                        // 你可以在这里添加更多语言
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}
