//
//  TitleSelectionView.swift
//  Enterty
//
//  Created by PandaSan on 11/6/24.
//

import SwiftUI

struct TitleSelectionView: View {
    let selectedTypes: [TitleType]
    
    var body: some View {
        Text("Title Selection View")
            .navigationTitle("Select Titles")
    }
}

#Preview {
    TitleSelectionView(selectedTypes: [.game, .book])
}

