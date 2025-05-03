import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var newItemTitle: String = ""
    
    @FocusState private var isFocused: Bool
    
    func addEssentialFoods() {
        let foods = [
            Item(title: "Bakety & Bread", isCompleted: false),
            Item(title: "Dairy", isCompleted: true),
            Item(title: "Meat & Seafood", isCompleted: .random()),
            Item(title: "Produce", isCompleted: .random()),
            Item(title: "Pantry", isCompleted: .random())
        ]
        for food in foods {
            modelContext.insert(food)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    Text(item.title)
                        .font(.title.weight(.light))
                        .padding(.vertical, 2)
                        .foregroundStyle(item.isCompleted ? Color.accentColor : Color.primary)
                        .strikethrough(item.isCompleted)
                        .italic(item.isCompleted)
                        .swipeActions {
                            Button(role: .destructive) {
                                withAnimation {
                                    modelContext.delete(item)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        } //: SWIPE
                        .swipeActions(edge: .leading) {
                            Button {
                                item.isCompleted.toggle()
                            } label: {
                                Label("Done", systemImage: item.isCompleted ? "x.circle" : "checkmark.circle")
                            }
                            .tint(item.isCompleted ? .accentColor : .green)
                        } //: SWIPE
                } //: FOREACH
            } //: LIST
            .navigationTitle("Grocery List")
            .toolbar {
                if items.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: addEssentialFoods) {
                            Label("Essential Foods", systemImage: "carrot")
                        }
                    }
                }
            }
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView(
                        "Empty Cart",
                        systemImage: "cart.circle",
                        description: Text("Add some items to your cart")
                    )
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 12) {
                    TextField("Add new glocery item", text : $newItemTitle)
                        .textFieldStyle(.plain)
                        .padding(12)
                        .background(.tertiary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .font(.title.weight(.light))
                        .focused($isFocused)
                    Button {
                        if newItemTitle.isEmpty { return }
                        let newItem = Item(title: newItemTitle, isCompleted: false)
                        modelContext.insert(newItem)
                        newItemTitle = ""
                        isFocused = false
                    } label : {
                        Text("Save")
                            .font(.title2.weight(.medium))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle)
                    .controlSize(.extraLarge)
                }
                .padding()
                .background(.bar)
            }

        }
    }
}

#Preview("Sample Data") {
    let sampleData = [
        Item(title: "Bakety & Bread", isCompleted: false),
        Item(title: "Dairy", isCompleted: true),
        Item(title: "Meat & Seafood", isCompleted: .random()),
        Item(title: "Produce", isCompleted: .random()),
        Item(title: "Pantry", isCompleted: .random())
    ]
    
    let container = try! ModelContainer(
        for: Item.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    
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
