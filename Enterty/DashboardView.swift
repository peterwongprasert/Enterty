//
//  DashboardView.swift
//  Enterty
//
//  Created by PandaSan on 11/6/24.
//
import SwiftUI
import CoreData
import Foundation

struct DashboardView: View {
    @State private var userTitles: [Title] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    let userEmail: String
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading your titles...")
                } else if let error = errorMessage {
                    VStack {
                        Text("Error: \(error)")
                        Button("Retry") {
                            Task {
                                await loadUserTitles()
                            }
                        }
                    }
                } else {
                    List {
                        ForEach(userTitles) { title in
                            TitleRow(title: title, userEmail: userEmail)
                        }
                    }
                }
            }
            .navigationTitle("My Entertainment")
            .toolbar {
                Button("Add Title") {
                    // Show title selection view
                }
            }
        }
        .task {
            await loadUserTitles()
        }
    }
    
    private func loadUserTitles() async {
        isLoading = true
        errorMessage = nil
        
        do {
            userTitles = try await EntertainmentAPI.shared.getUserTitles(email: userEmail)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

struct TitleRow: View {
    let title: Title
    let userEmail: String
    @State private var isUpdating = false
    @State private var startDate: Date?
    @State private var endDate: Date?
    @State private var lastAccessDate: Date?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title.name)
                .font(.headline)
            Text(title.type)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                if startDate == nil {
                    Button("Start") {
                        Task {
                            await startTitle()
                        }
                    }
                } else if endDate == nil {
                    Button("End") {
                        Task {
                            await endTitle()
                        }
                    }
                } else {
                    Button("Restart") {
                        Task {
                            await restartTitle()
                        }
                    }
                    if let lastAccess = lastAccessDate {
                        Text("\(daysSinceLastAccess(lastAccess)) days ago")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .disabled(isUpdating)
        }
        .task {
            await loadTitleDates()
        }
    }
    
    private func loadTitleDates() async {
        do {
            let collection = try await EntertainmentAPI.shared.getTitleDates(titleId: title.id, userEmail: userEmail)
            startDate = collection.startDate
            endDate = collection.endDate
            lastAccessDate = collection.lastAccessDate
        } catch {
            print("Error loading dates: \(error)")
        }
    }
    
    private func startTitle() async {
        isUpdating = true
        do {
            try await EntertainmentAPI.shared.updateTitleDates(
                titleId: title.id,
                userEmail: userEmail,
                startDate: Date(),
                endDate: nil,
                lastAccessDate: Date()
            )
            await loadTitleDates()
        } catch {
            print("Error starting title: \(error)")
        }
        isUpdating = false
    }
    
    private func endTitle() async {
        isUpdating = true
        do {
            try await EntertainmentAPI.shared.updateTitleDates(
                titleId: title.id,
                userEmail: userEmail,
                startDate: startDate,
                endDate: Date(),
                lastAccessDate: Date()
            )
            await loadTitleDates()
        } catch {
            print("Error ending title: \(error)")
        }
        isUpdating = false
    }
    
    private func restartTitle() async {
        isUpdating = true
        do {
            try await EntertainmentAPI.shared.updateTitleDates(
                titleId: title.id,
                userEmail: userEmail,
                startDate: Date(),
                endDate: nil,
                lastAccessDate: Date()
            )
            await loadTitleDates()
        } catch {
            print("Error restarting title: \(error)")
        }
        isUpdating = false
    }
    
    private func daysSinceLastAccess(_ date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
    }
}
