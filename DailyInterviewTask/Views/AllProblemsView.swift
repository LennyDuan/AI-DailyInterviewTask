import SwiftUI

struct AllProblemsView: View {
    @EnvironmentObject private var appSettings: AppSettings
    @EnvironmentObject private var appNavigation: AppNavigation
    @StateObject private var viewModel: AllProblemsViewModel

    @State private var searchText = ""
    @State private var selectedTopic = "All"

    private let progressStorage: ProgressStorageServicing

    init(repository: QuestionRepository, progressStorage: ProgressStorageServicing) {
        _viewModel = StateObject(
            wrappedValue: AllProblemsViewModel(
                repository: repository,
                progressStorage: progressStorage
            )
        )
        self.progressStorage = progressStorage
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("All Problems")
                        .font(.largeTitle.weight(.bold))

                    Text("Browse the full Algo Daily set by topic and status.")
                        .foregroundStyle(.secondary)

                    topicFilter

                    LazyVStack(spacing: 12) {
                        ForEach(filteredQuestions) { question in
                            NavigationLink {
                                QuestionDetailView(
                                    viewModel: QuestionDetailViewModel(
                                        question: question,
                                        progressStorage: progressStorage
                                    )
                                )
                            } label: {
                                QuestionRowView(
                                    question: question,
                                    isCompleted: viewModel.isCompleted(question),
                                    isBookmarked: viewModel.isBookmarked(question)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .searchable(text: $searchText, prompt: "Search title or topic")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                viewModel.refresh()
                applySelectedTopicFilter()
            }
            .onChange(of: appNavigation.selectedTopicFilter) { _, _ in
                applySelectedTopicFilter()
            }
        }
    }

    private var filteredQuestions: [Question] {
        viewModel.questions.filter { question in
            let matchesTopic = selectedTopic == "All" || question.topic == selectedTopic
            let localizedTitle = question.title.value(for: appSettings.selectedLanguage)
            let matchesSearch = searchText.isEmpty
                || localizedTitle.localizedCaseInsensitiveContains(searchText)
                || question.topic.localizedCaseInsensitiveContains(searchText)
            return matchesTopic && matchesSearch
        }
    }

    private var topicFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                filterChip(title: "All")
                ForEach(viewModel.topics, id: \.self) { topic in
                    filterChip(title: topic)
                }
            }
        }
    }

    private func filterChip(title: String) -> some View {
        Button {
            selectedTopic = title
            appNavigation.selectedTopicFilter = title
        } label: {
            Text(title)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(selectedTopic == title ? .white : .primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    Capsule(style: .continuous)
                        .fill(selectedTopic == title ? Color.blue : Color.white)
                )
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color.black.opacity(selectedTopic == title ? 0 : 0.08), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    private func applySelectedTopicFilter() {
        let requestedTopic = appNavigation.selectedTopicFilter
        selectedTopic = requestedTopic == "All" || viewModel.topics.contains(requestedTopic)
            ? requestedTopic
            : "All"
    }
}
