//
//  FavoritesManager.swift
//  FactFlict
//
//  Created by Haitham Alnajar on 11/8/23.
//

import Foundation

class FavoritesManager {
    
    static let shared = FavoritesManager()
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "favoritesKey"
    
    func addFavorite(_ item: String) {
            var favorites = getFavorites()
            favorites.append(item)
            saveFavorites(favorites)
        }
    
    func removeFavorite(_ item: String) {
            var favorites = getFavorites()
            if let index = favorites.firstIndex(of: item) {
                favorites.remove(at: index)
                saveFavorites(favorites)
            }
        }
    
    func isFavorite(_ item: String) -> Bool {
            let favorites = getFavorites()
            return favorites.contains(item)
        }

    func getFavorites() -> [String] {
            if let favorites = userDefaults.stringArray(forKey: favoritesKey) {
                return favorites
            }
            return []
        }

    private func saveFavorites(_ favorites: [String]) {
            userDefaults.set(favorites, forKey: favoritesKey)
        }
    
    func clearFavorites() {
            userDefaults.removeObject(forKey: favoritesKey)
        }
    
    func numberOfFavorites() -> Int {
            return getFavorites().count
        }
}
