import Foundation

protocol QuestionRepository {
    func loadQuestions() throws -> [Question]
}

enum QuestionRepositoryError: LocalizedError {
    case fileNotFound
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "questions.json could not be found in the app bundle."
        case .decodingFailed:
            return "questions.json could not be decoded."
        }
    }
}

struct LocalQuestionRepository: QuestionRepository {
    private let bundle: Bundle
    private let fileName: String

    init(bundle: Bundle = .main, fileName: String = "questions") {
        self.bundle = bundle
        self.fileName = fileName
    }

    func loadQuestions() throws -> [Question] {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw QuestionRepositoryError.fileNotFound
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Question].self, from: data)
        } catch {
            throw QuestionRepositoryError.decodingFailed
        }
    }
}
