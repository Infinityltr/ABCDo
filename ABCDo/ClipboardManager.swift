import Foundation
import UIKit
import NaturalLanguage

class ClipboardManager {
    func processClipboard() -> (title: String, startDate: Date?, endDate: Date?)? {
        if let clipboardText = UIPasteboard.general.string {
            return recognizeTask(from: clipboardText)
        } else {
            print("No text found in clipboard")
            return nil
        }
    }

    private func recognizeTask(from text: String) -> (title: String, startDate: Date?, endDate: Date?)? {
        var taskTitle = ""
        var startDate: Date?
        var endDate: Date?
        
        // 使用NLTagger提取任务标题部分
        let tagger = NLTagger(tagSchemes: [.nameType, .lexicalClass])
        tagger.string = text

        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .nameTypeOrLexicalClass, options: options) { tag, tokenRange in
            let word = String(text[tokenRange])
            if let tag = tag {
                switch tag {
                case .personalName, .organizationName, .placeName:
                    taskTitle += word + " "
                default:
                    break
                }
            }
            return true
        }

        // 使用NSLinguisticTagger提取日期和时间
        let dateDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
        let matches = dateDetector?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))

        var dates: [Date] = []

        matches?.forEach { match in
            if let date = match.date {
                dates.append(date)
            }
        }

        if dates.count > 0 {
            startDate = dates.first
            endDate = dates.count > 1 ? dates[1] : nil
        }

        return (title: taskTitle.trimmingCharacters(in: .whitespacesAndNewlines), startDate: startDate, endDate: endDate)
    }
}
