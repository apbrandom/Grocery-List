//
//  ContentView.swift
//  Grocery List
//
//  Created by Vadim Vinogradov on 4/29/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var item: [Item]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(item) { item in
                    Text(item.title)
                        .font(.title.weight(.light))
                        .padding(.vertical, 2)
                        .foregroundStyle(item.isCompleted == false ? Color.primary : Color.accentColor)
                        .strikethrough(item.isCompleted)
                        .italic(item.isCompleted)
                }
            } //: LIST
            .navigationTitle("Grocery List")
            .overlay {
                if item.isEmpty {
                    ContentUnavailableView("Empty Cart", systemImage: "cart.circle", description: Text("Add some items to your cart"))
                }
 
            }
        }
    }
}

#Preview("Sample Data") {
    let sampleData: [Item] = [
        Item(title: "Bakety & Bread", isCompleted: false),
        Item(title: "Dairy", isCompleted: true),
        Item(title: "Meat & Seafood", isCompleted: .random()),
        Item(title: "Produce", isCompleted: .random()),
        Item(title: "Pantry", isCompleted: .random()),
    ]
    
    let container = try! ModelContainer(for: Item.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    for item in sampleData {
        container.mainContext.insert(item)
    }

    return ContentView()
        .modelContainer(container)
        
}

#Preview("Empty List") {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
