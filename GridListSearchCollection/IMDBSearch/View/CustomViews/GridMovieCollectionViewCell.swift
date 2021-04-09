//
//  GridMovieCollectionViewCell.swift
//  GridListSearchCollection
//
//  Created by Ankit Thakur on 09/04/21.
//

import UIKit
import SDWebImage

class GridMovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel :UILabel!
    @IBOutlet weak var movieImageView :UIImageView!
    
    func loadMovie(_ movie: Movie) {
        titleLabel.text = movie.title
        movieImageView.image = R.image.placeHolderImage()
        movieImageView.sd_setImage(with: URL(string: movie.posterURL), placeholderImage: R.image.placeHolderImage())
    }
}
