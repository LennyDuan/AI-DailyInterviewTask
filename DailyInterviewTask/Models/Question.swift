import Foundation

struct Question: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let difficulty: Difficulty
    let topic: String
    let shortSummary: String
    let companyTags: [String]
    let description: String
    let exampleInput: String
    let exampleOutput: String
    let exampleExplanation: String
    let constraints: [String]
    let solution: QuestionSolution
}

extension Question {
    enum Difficulty: String, Codable, CaseIterable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
}

struct QuestionSolution: Codable, Equatable {
    let approachName: String
    let intuition: String
    let steps: [String]
    let whyOptimal: String
    let timeComplexity: String
    let spaceComplexity: String
    let commonMistakes: [String]
    let interviewTip: String
    let pythonCode: String
}
