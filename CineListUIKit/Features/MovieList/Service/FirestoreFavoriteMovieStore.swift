//
//  FirestoreFavoriteMovieStore.swift
//  CineListUIKit
//
//  Created by breno.farias on 22/09/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class FirestoreFavoriteMovieStore: FavoriteMovieStoring {
    private let db = Firestore.firestore()
    
    private(set) var favorites: [Movie] = []
    
    private var userId: String {
        guard let userID = Auth.auth().currentUser?.uid else {
            return ""
        }
        return userID
    }
    
    private var favoritesCollection: CollectionReference {
        db.collection("users")
            .document(userId)
            .collection("favorites")
    }
    
    func load() async throws {
        guard !userId.isEmpty else {
            favorites = []
            return
        }
        
        let snapshot = try await favoritesCollection.getDocuments()
        favorites = try snapshot.documents.compactMap { document in
            try document.data(as: Movie.self)
        }
    }
    
    func isFavorite(_ movie: Movie) -> Bool {
        favorites.contains { $0.id == movie.id }
    }
    
    func toggle(_ movie: Movie) async throws {
        guard !userId.isEmpty else { throw FirestoreFavoriteError.userNotAuthenticated }
        
        let document = favoritesCollection.document(String(movie.id))
        
        if isFavorite(movie) {
            try await document.delete()
            favorites.removeAll { $0.id == movie.id }
        } else {
            try document.setData(from: movie)
            favorites.append(movie)
        }
    }
}

enum FirestoreFavoriteError: LocalizedError {
    case userNotAuthenticated
    
    var errorDescription: String? {
        switch self {
        case .userNotAuthenticated:
            return "Nenhum usuário autenticado"
        }
    }
}
    
