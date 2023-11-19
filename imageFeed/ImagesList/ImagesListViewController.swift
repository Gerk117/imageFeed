//
//  ViewController.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 06.09.2023.
//

import UIKit
import Kingfisher
protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListViewController: UIViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var observer : NSObjectProtocol?
    private var imagesListService = ImagesListService.shared
    @IBOutlet private var tableView: UITableView!
    private var photos = [Photo]()
    weak var delegate: ImagesListCellDelegate?
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        observer = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification ,
                                                          object: nil,
                                                          queue: .main,
                                                          using: { [weak self] _ in
            guard let self else {return}
            updateTableViewAnimated()
        })
        imagesListService.fetchPhotosNextPage { _ in }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: ImagesListService.didChangeNotification, object: nil)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as? SingleImageViewController
            if let indexPath = sender as? IndexPath {
                let photo = photos[indexPath.row]
                viewController?.imageUrl =  photo.largeImageURL
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func configCell(for cell: ImagesListCell?, with indexPath: IndexPath) {
        let model = photos[indexPath.row]
        cell?.delegate = self
        cell?.imageViewCell.kf.indicatorType = .activity
        cell?.imageViewCell.kf.setImage(with: URL(string: model.thumbImageURL),placeholder: UIImage(named: "stub")){_ in
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            cell?.imageViewCell.kf.indicatorType = .none
        }
        if let date = model.createdAt {
            cell?.dateOfImageLabel.text = formatter.string(from: date)
            cell?.dateOfImageLabel.layer.insertSublayer(cell!.gradientLayer, at: 0)
        } else{
            cell?.dateOfImageLabel.text = ""
        }
        cell?.setIsLiked(isLiked: model.isLiked)
    }
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
    
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell
        configCell(for: cell, with: indexPath)
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage { _ in }
        }
    }
}



extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        let size = photo.size
        let aspectRatio = size.width / size.height
        return tableView.frame.width / aspectRatio
    }
}
extension ImagesListViewController : ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { result in
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                self.tableView.reloadRows(at: [indexPath], with: .none)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    
}
