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
    
    
    var viewModel: GameDetailViewModel! {
        didSet {
            if viewModel != nil { viewModel.delegate = self }
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupRightBarButton(animated: animated)
    }
    
    
    // MARK: - Setup UI
    
    private func setupRightBarButton(animated: Bool) {
        let buttonTitle = viewModel.isGameFavorited ?  S.favorited : S.favorite
         let favoriteBarButtonItem = UIBarButtonItem(title: buttonTitle, style: .plain, target: self, action: #selector(favoriteTapped))
        navigationItem.setRightBarButton(favoriteBarButtonItem, animated: animated)
    }
    
    private func setupTableView() {
        webRedirectionsTableView.delegate = self
        webRedirectionsTableView.dataSource = self
        webRedirectionsTableView.tableFooterView = UIView()
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
    }
    
    
    // MARK: - Helpers
    
    private func updateTextViewHeight(for constant: CGFloat) {
        descriptionHeightConstraint.constant = constant
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func favoriteTapped() {
        viewModel.handleFavoriteAction()
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
                debugPrint(error.localizedDescription)            }
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
