//
//  ContentView.swift
//  Bookworm
//
//  Created by Brandon Coston on 9/3/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.title),
        SortDescriptor(\.author)
    ]) var books: FetchedResults<Book>
    
    @State var showingAddScreen = false

    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in
                    NavigationLink {
                        DetailView(book: book)
                    } label: {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text(book.title ?? "Unknown Title")
                                    .font(.headline)
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddScreen.toggle()
                    } label: {
                        Label("Add Book", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            
            moc.delete(book)
        }
        
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static let dataController = DataController.shared
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}


/* How to combine Core Data and SwiftUI */
//struct ContentView: View {
//    @FetchRequest(sortDescriptors: []) var students: FetchedResults<Student>
//    @Environment(\.managedObjectContext) var moc
//
//    var body: some View {
//        VStack {
//            List(students) { student in
//                Text(student.name ?? "Unknown")
//            }
//            Button("Add") {
//                let firstNames = ["Ginny", "Harry", "Hermione", "Luna", "Ron"]
//                let lastNames = ["Granger", "Lovegood", "Potter", "Weasley"]
//
//                let chosenFirstName = firstNames.randomElement()!
//                let chosenLastName = lastNames.randomElement()!
//
//                let student = Student(context: moc)
//                student.id = UUID()
//                student.name = "\(chosenFirstName) \(chosenLastName)"
//
//                try? moc.save()
//            }
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static let dataController = DataController()
//
//    static var previews: some View {
//        ContentView()
//            .environment(\.managedObjectContext, dataController.container.viewContext)
//    }
//}


/* Accepting multi-line text input with TextEditor */
//struct ContentView: View {
//    @AppStorage("notes") private var notes = ""
//
//    var body: some View {
//        NavigationView {
//            TextEditor(text: $notes)
//                .navigationTitle("Notes")
//                .padding()
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


/* Creating a custom component with @Binding */
//struct ContentView: View {
//    @State private var rememberMe = false
//    var body: some View {
//        VStack {
//            PushButton(title: "Remember Me", isOn: $rememberMe)
//            Text(rememberMe ? "On" : "Off")
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//
//struct PushButton: View {
//    let title: String
//    @Binding var isOn: Bool
//
//    var onColors = [Color.red, Color.white]
//    var offColors = [Color(white: 0.6), Color(white: 0.4)]
//
//    var body: some View {
//        Button(title) {
//            isOn.toggle()
//        }
//        .padding()
//        .background(LinearGradient(gradient: Gradient(colors: isOn ? onColors : offColors), startPoint: .top, endPoint: .bottom))
//        .foregroundColor(.white)
//        .clipShape(Capsule())
//        .shadow(radius: isOn ? 0 : 5)
//    }
//}
