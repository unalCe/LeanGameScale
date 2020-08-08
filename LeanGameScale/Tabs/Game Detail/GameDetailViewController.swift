//
//  GameDetailViewController.swift
//  LeanGameScale
//
//  Created by Unal Celik on 3.08.2020.
//  Copyright © 2020 unalCe. All rights reserved.
//

import UIKit
import Kingfisher

class GameDetailViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var titleGradientView: UIView!
    
    @IBOutlet weak var gameNameLabel: UILabel!
    
    @IBOutlet weak var gameDescription: UITextView!
    @IBOutlet weak var descriptionHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var webRedirectionsTableView: UITableView!
    
    private var titleGradient: CAGradientLayer!
    
    var viewModel: GameDetailViewModel! {
        didSet {
            if viewModel != nil { viewModel.delegate = self }
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitleGradientView()
        setupDescriptionTextViewHeight(maximumNumberOfLines: 4)
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupRightBarButton(animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleGradient.frame = titleGradientView.bounds
    }
    
    
    // MARK: - Setup UI
    
    private func setupRightBarButton(animated: Bool) {
        let buttonTitle = viewModel.isGameFavorited ?  S.favorited : S.favorite
        let favoriteBarButtonItem = UIBarButtonItem(title: buttonTitle, style: .plain, target: self, action: #selector(favoriteTapped))
        navigationItem.setRightBarButton(favoriteBarButtonItem, animated: animated)
    }
    
    private func setupTitleGradientView() {
        titleGradient = CAGradientLayer()
        titleGradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.75).cgColor, UIColor.black.cgColor]
        titleGradient.locations = [0.0, 0.5, 1.0]
        titleGradientView.layer.insertSublayer(titleGradient, at: 0)
    }
    
    private func setupTableView() {
        webRedirectionsTableView.delegate = self
        webRedirectionsTableView.dataSource = self
        webRedirectionsTableView.tableFooterView = UIView()
    }
    
    private func setupDescriptionTextViewHeight(maximumNumberOfLines: Int) {
        let lineHeights = CGFloat(maximumNumberOfLines) * (gameDescription.font?.lineHeight ?? 0)
        let containerInsets = gameDescription.textContainerInset.top + gameDescription.textContainerInset.bottom
        descriptionHeightConstraint.constant = (lineHeights + containerInsets)
    }
    
    private func updateUI() {
        let game = viewModel.game
        
        gameImageView.kf.setImage(with: game?.backgroundImage,
                                  options: [
                                    .scaleFactor(UIScreen.main.scale),
                                    .transition(.fade(0.5)),
                                    .cacheOriginalImage
        ])
        
        gameNameLabel.text = game?.name
        gameDescription.text = game?.description?.htmlToString
        gameDescription.addTrailing(moreText: S.readMore, moreTextFont: .systemFont(ofSize: 14, weight: .semibold), moreTextColor: .blue)
    }
    
    
    // MARK: - Helpers
    
    @IBAction private func textViewTapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let location = sender.location(in: gameDescription)
            let tappedWord = gameDescription.wordAtPosition(point: location)
            
            if tappedWord == S.readMore {
                collapseTextView()
            }
        }
    }
    
    private func collapseTextView() {
        gameDescription.attributedText = nil
        gameDescription.text = viewModel.game?.description?.htmlToString
        
        let estimatedSize = gameDescription.sizeThatFits(CGSize(width: gameDescription.bounds.width,
                                                                height: .greatestFiniteMagnitude))
        descriptionHeightConstraint.constant = estimatedSize.height
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func favoriteTapped() {
        if viewModel.isGameFavorited {
            viewModel.removeFavoritedGame()
        } else {
            // This data doesn't have to be in high quality because it's only showed in the small cell image
            let imageData = gameImageView.image?.jpegData(compressionQuality: 0.6)
            viewModel.saveFavoritedGame(with: imageData)
        }
    }
}


// MARK: - GameDetailViewModelDelegate
extension GameDetailViewController: GameDetailViewModelDelegate {
    func handleGameDetailState(_ state: GameDetailModelState) {
        DispatchQueue.main.async {
            switch state {
            case .isLoadingData(let isLoading):
                isLoading ? self.startAnimating() : self.stopAnimating()
            case .dataReady:
                self.updateUI()
                self.webRedirectionsTableView.reloadData()
            case .requestFailed(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func updateFavoriteStatus(_ isFavorite: Bool) {
        navigationItem.rightBarButtonItem?.title = isFavorite ? S.favorited : S.favorite
    }
}


extension GameDetailViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "webTableCell", for: indexPath)
        
        let leftText = indexPath.row == 0 ? S.visitWeb : S.visitReddit
        let detailText = indexPath.row == 0 ? nil : viewModel.game?.redditName
        cell.textLabel?.text = leftText
        cell.detailTextLabel?.text = detailText
        
        return cell
    }
    
    // MARK: - Table Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: Handle ...
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // This is for the separator line on top
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        1
    }
}
