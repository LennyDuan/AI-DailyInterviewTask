//
//  ContentView.swift
//  DailyInterviewTask
//
//  Created by Hongyi Duan on 15/03/2026.
//

import SwiftUI

struct ContentView: View {
    private let repository = LocalQuestionRepository()
    private let progressStorage = ProgressStorageService()

    var body: some View {
        RootTabView(repository: repository, progressStorage: progressStorage)
    }
}

#Preview {
    ContentView()
}
