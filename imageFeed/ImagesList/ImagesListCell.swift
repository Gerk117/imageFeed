//
//  ImagesListCell.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 14.09.2023.
//

import UIKit
import Kingfisher

final class ImagesListCell : UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateOfImageLabel: UILabel!
    @IBOutlet weak var imageViewCell: UIImageView!
    weak var delegate: ImagesListCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewCell.kf.cancelDownloadTask()
    }
    var gradientLayer : CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 26, green: 27, blue: 34, alpha: 0.2).cgColor,
                           UIColor(red: 26, green: 27, blue: 34, alpha: 0).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = dateOfImageLabel.bounds
        return gradient
    }
    func setIsLiked(isLiked:Bool) {
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}
