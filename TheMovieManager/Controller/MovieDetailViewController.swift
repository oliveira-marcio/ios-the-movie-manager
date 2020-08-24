//
//  MovieDetailViewController.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var watchlistBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var favoriteBarButtonItem: UIBarButtonItem!
    
    var movie: Movie!
    
    var isWatchlist: Bool {
        return MovieModel.watchlist.contains(movie)
    }
    
    var isFavorite: Bool {
        return MovieModel.favorites.contains(movie)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = movie.title
        
        toggleBarButton(watchlistBarButtonItem, enabled: isWatchlist)
        toggleBarButton(favoriteBarButtonItem, enabled: isFavorite)
        
    }
    
    @IBAction func watchlistButtonTapped(_ sender: UIBarButtonItem) {
        TMDBClient.markWatchlist(mediaId: movie.id, watchList: !isWatchlist, completion: handleWatchlistResponse(success:error:))
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        TMDBClient.markFavorite(mediaId: movie.id, favorite: !isFavorite, completion: handleFavoriteResponse(success:error:))
    }
    
    func handleWatchlistResponse(success: Bool, error: Error?) {
        if success {
            if isWatchlist {
                MovieModel.watchlist = MovieModel.watchlist.filter() { $0 != self.movie }
                print("'\(movie.title)' removed from watchlist")
            } else {
                MovieModel.watchlist.append(movie)
                print("'\(movie.title)' added to watchlist")
            }
            
            toggleBarButton(watchlistBarButtonItem, enabled: isWatchlist)
        }
    }
    
    func handleFavoriteResponse(success: Bool, error: Error?) {
        if success {
            if isFavorite {
                MovieModel.favorites = MovieModel.favorites.filter() { $0 != self.movie }
                print("'\(movie.title)' removed from favorites")
            } else {
                MovieModel.favorites.append(movie)
                print("'\(movie.title)' added to favorites")
            }
            
            toggleBarButton(favoriteBarButtonItem, enabled: isFavorite)
        }
    }
    
    func toggleBarButton(_ button: UIBarButtonItem, enabled: Bool) {
        if enabled {
            button.tintColor = UIColor.primaryDark
        } else {
            button.tintColor = UIColor.gray
        }
    }
    
    
}
