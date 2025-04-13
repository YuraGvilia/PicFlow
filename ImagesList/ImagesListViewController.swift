//
//  ImagesListViewController.swift
//  PicFlow
//
//  Created by Yura Gvilia on 23.03.2025.
//

import UIKit

final class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!

    private let photoNames = (0..<20).map { "\($0)" }

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photoNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ImagesListCell.reuseIdentifier,
                for: indexPath
            ) as? ImagesListCell
        else {
            return UITableViewCell()
        }

        configure(cell, at: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photoNames[indexPath.row]) else { return 0 }

        let insets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let width = tableView.bounds.width - insets.left - insets.right
        let scale = width / image.size.width
        return image.size.height * scale + insets.top + insets.bottom
    }
}

// MARK: - Cell Configuration

private extension ImagesListViewController {
    func configure(_ cell: ImagesListCell, at indexPath: IndexPath) {
        guard let image = UIImage(named: photoNames[indexPath.row]) else { return }

        cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())

        let isLiked = indexPath.row % 2 == 0
        let likeIcon = isLiked ? "like_button_on" : "like_button_off"
        cell.likeButton.setImage(UIImage(named: likeIcon), for: .normal)
    }
}
