//
//  TitleTypeSelectionView.swift
//  Enterty
//
//  Created by PandaSan on 10/19/24.
//

import SwiftUI
import CoreData

enum TitleType: String, CaseIterable {
    case game = "Games"
    case book = "Books"
    case tvshow = "TV Shows"
}

struct TitleTypeSelectionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedTypes: Set<TitleType> = []
    @State private var navigateToCatalog = false

    var body: some View {
        VStack(spacing: 20) {
            Text("What types of entertainmenet do you enjoy?")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()

            ForEach(TitleType.allCases, id: \.self) { type in
                Button(action: {
                    if selectedTypes.contains(type) {
                        selectedTypes.remove(type)
                    } else {
                        selectedTypes.insert(type)
                    }
                }) {
                    HStack {
                        Text(type.rawValue)
                        Spacer()
                        if selectedTypes.contains(type) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                        }
                    }.padding()
                        .background(
                            RoundedRectangle(cornerRadius:10)
                                .stroke(selectedTypes.contains(type) ? Color.accentColor : Color.gray , lineWidth:2)
                        )
                }.foregroundColor(.primary)
            }.padding(.horizontal)
            
            
            NavigationLink(destination: TitleSelectionView(selectedTypes: Array(selectedTypes)), isActive: $navigateToCatalog){
                Button(action :{
                    if !selectedTypes.isEmpty {
                        navigateToCatalog = true
                    }
                }) {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(self.selectedTypes.isEmpty ? Color.gray.opacity(0.3) : Color.accentColor)
                        .cornerRadius(10)
                }
            }.disabled(selectedTypes.isEmpty)
                .padding(.horizontal)
        
        }.navigationTitle("Welcome!")
    }

}

// Add a preview provider
#Preview {
    TitleTypeSelectionView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
