//
//  DetailView.swift
//  Bookworm
//
//  Created by Brandon Coston on 9/3/23.
//

import CoreData
import SwiftUI

struct DetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    let book: Book
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                Image(book.genre ?? "Fantasy")
                    .resizable()
                    .scaledToFit()
                Text(book.genre?.uppercased() ?? "FANTASY")
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(x: -5, y:-5)
            }
            Text(book.author ?? "Unknown author")
                .font(.title)
                .foregroundColor(.secondary)
            
            HStack {
                Text("Review Date: \((book.date ?? Date.now)!.formatted(date: .abbreviated, time: .omitted))")
                    .underline()
                Spacer()
            }
            .padding([.leading, .trailing, .top])
            Text(book.review ?? "No review")
                .padding([.leading, .trailing, .bottom])
                    
                    RatingView(rating: .constant(Int(book.rating)))
                        .font(.largeTitle)
        }
        .navigationTitle(book.title ?? "Unknown Book")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete book", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteBook)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure?")
        }
        .toolbar {
            Button {
                showingDeleteAlert.toggle()
            } label: {
                Label("Delete this book", systemImage: "trash")
            }
        }
    }
    
    func deleteBook() {
        moc.delete(book)
        
        try? moc.save()
        dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = DataController.preview.container.viewContext
    
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test Book"
        book.author = "Test Author"
        book.genre = "LitRPG"
        book.rating = 4
        book.review = "This was a great book; I really enjoyed it. I also want to pad out this review by quite a bit to see what it looks like with long text"
        book.date = Date.now
        
        return NavigationView {
            DetailView(book: book)
        }
    }
}
