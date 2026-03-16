import Foundation

enum AppLanguage: String, Codable, CaseIterable, Identifiable {
    case english
    case chinese

    var id: String { rawValue }

    var title: String {
        switch self {
        case .english:
            return "EN"
        case .chinese:
            return "中文"
        }
    }
}

struct LocalizedText: Codable, Equatable, Hashable {
    let english: String
    let chinese: String

    func value(for language: AppLanguage) -> String {
        switch language {
        case .english:
            return english
        case .chinese:
            return chinese
        }
    }
}

struct Question: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let title: LocalizedText
    let difficulty: Difficulty
    let topic: String
    let shortSummary: LocalizedText
    let companyTags: [String]
    let description: LocalizedText
    let exampleInput: String
    let exampleOutput: String
    let exampleExplanation: LocalizedText
    let constraints: [LocalizedText]
    let notes: [LocalizedText]
    let solutions: [QuestionSolution]

    var optimalSolution: QuestionSolution {
        solutions.first(where: \.isOptimal) ?? solutions[0]
    }
}

extension Question {
    enum Difficulty: String, Codable, CaseIterable, Hashable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
}

struct QuestionSolution: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let title: LocalizedText
    let isOptimal: Bool
    let intuition: LocalizedText
    let steps: [LocalizedText]
    let explanation: LocalizedText
    let timeComplexity: String
    let spaceComplexity: String
    let notes: [LocalizedText]
    let pythonCode: String
}

struct TopicProgress: Identifiable, Equatable {
    let topic: String
    let completedCount: Int
    let totalCount: Int

    var id: String { topic }

    var percentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }
}
