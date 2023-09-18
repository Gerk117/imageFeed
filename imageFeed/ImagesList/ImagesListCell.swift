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
    static let reuseIdentifier = "ImagesListCell"
}
