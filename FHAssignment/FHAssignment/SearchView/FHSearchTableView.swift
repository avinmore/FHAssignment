//
//  FHSearchTableView.swift
//  FHAssignment
//
//  Created by Avin on 19/03/20.
//  Copyright © 2020 avin. All rights reserved.
//

import Foundation
import UIKit

class FHSearchTableView: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    private let viewModel = FHSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    private func serachImageFor(queryString: String, index: IndexPath = IndexPath(item: 0, section:0)) {
        viewModel.searchImage(for: index)
    }
    
    private func setupViewModel() {
        
        viewModel.updateTableView = {
            DispatchQueue.main.async { [weak self] in
             self?.collectionView.reloadData()
            }
        }
        
        viewModel.networkActivity = { shouldShow in
            DispatchQueue.main.async { [weak self] in
                if shouldShow {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.showError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let alert: UIAlertController = UIAlertController(
                    title: "Error", message: errorMessage, preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension FHSearchTableView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.queryString = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.resetData()
        serachImageFor(queryString: viewModel.queryString)
        view.endEditing(true)
    }
}

extension FHSearchTableView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "FHTileCollectionCell", for: indexPath
            ) as? FHTileCollectionCell else {
            return UICollectionViewCell()
        }
        let imageData = viewModel.imageList[indexPath.row]
        cell.setupCell(data: imageData)  { image in
            DispatchQueue.main.async { [weak cell] in
                cell?.imageView.image = image
            }
        }
        return cell
    }
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width - 30
        let scaleFactor = (screenWidth / 2)
        return CGSize(width: scaleFactor, height: scaleFactor)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let preview = UIStoryboard(
            name: "Main",
            bundle: nil).instantiateViewController(
                withIdentifier: "FHImagePreview") as? FHImagePreview else {
                return
        }
        let imageData = viewModel.imageList[indexPath.row]
        preview.imageURLString = imageData.url
        present(preview, animated: false, completion: nil)
    }
    
    //TODO: Can user pre-fetch delegate here.
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.fetchNextPage(index: indexPath)
    }
}
