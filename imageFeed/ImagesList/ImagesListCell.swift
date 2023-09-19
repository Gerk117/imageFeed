//
//  ImagesListCell.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 14.09.2023.
//

import UIKit

final class ImagesListCell : UITableViewCell {
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateOfImageLabel: UILabel!
    @IBOutlet weak var imageViewCell: UIImageView!
    var gradientLayer : CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 26, green: 27, blue: 34, alpha: 0.2).cgColor, UIColor(red: 26, green: 27, blue: 34, alpha: 0).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = dateOfImageLabel.bounds
        return gradient
    }
    static let reuseIdentifier = "ImagesListCell"
}
