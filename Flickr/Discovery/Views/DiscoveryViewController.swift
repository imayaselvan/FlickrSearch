//
//  DiscoveryViewController.swift
//  Flickr
//
//  Created by Imayaselvan Ramakrishnan on 17/01/19.
//  Copyright © 2019 Imayaselvan Ramakrishnan. All rights reserved.
//

import UIKit

import Kingfisher
import DropDown

class DiscoveryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var recentSearches = RecentSearches()
    var cellsPerRow:CGFloat = 2
    let cellPadding:CGFloat = 10
    
    let listingManager = PhotoListingsService()
    var photos: PhotoCollection!
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Flickr"
        setupSearchDropDown()
    }
    
    func setupSearchDropDown() {
        dropDown.anchorView = searchBar
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.backgroundColor = .white
        dropDown.direction = .bottom
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.renderPhotoListings(item)
        }
        
    }
    
    func loadRecentSearches() {
        //This will call from textShouldbegin Editing - FirstTime
        if (recentSearches.isRecentSearchesAvailable) {
            dropDown.dataSource = recentSearches.searches
        }
    }
    
    func renderPhotoListings(_ searchText:String) {
        let progressView = ProgressView.show(inView: view)
        listingManager.getPhotosList(key:searchText, page: 1) { (collection, error) in
            //TODO : Proper Error Handling
            if let error = error {
                print(" error: \(error.localizedDescription)")
                return
            }
            guard let collection = collection  else { return }
            DispatchQueue.main.async {
                self.photos = PhotoCollection.init(searchText: searchText, model: collection.photos.photos, total: collection.photos.totalPages)
                self.photos.delegate = self
                self.collectionView.reloadData()
                self.collectionView.setContentOffset(.zero, animated: true)
                progressView.removeFromSuperview()
            }
        }
    }
}


// MARK: UICollectionViewDataSource , UICollectionViewDelegateFlowLayout

extension DiscoveryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Stay Safe
        if self.photos != nil {
            return self.photos.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.imageView.kf.setImage(with: photos.models[indexPath.row].imageUrl())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PhotoListHeaderView", for: indexPath) as? PhotoListHeaderView {
            sectionHeader.titleLbl.text = "Photos"
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding = UIScreen.main.bounds.width - (cellPadding + cellPadding * cellsPerRow)
        let size = padding / cellsPerRow
        return CGSize(width: size, height: size)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        cellsPerRow = (traitCollection.verticalSizeClass == .compact) ? 3 : 2
        //TODO: Need to come up with better solution, Instead of reloading the entire collection view
        collectionView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // scrollView calls this delegate even if contentSize is still zero
        searchBar.resignFirstResponder()
        guard scrollView.contentSize != CGSize.zero else {
            return
        }
        guard self.photos != nil else {
            return
        }
        
        let halfPage = Float(photos.count / 2)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let pageLineSpacing = Float(layout.minimumLineSpacing) * halfPage
        let pageHeight = (halfPage * Float(100) + pageLineSpacing)
        let contentHeight = Float(scrollView.contentSize.height)
        let offsetY = Float(scrollView.contentOffset.y + scrollView.bounds.size.height)
        
        // did we scroll past second half of the last page, if yes, load more
        if offsetY > contentHeight - pageHeight {
            photos.loadMore()
        }
    }
    
}

// PhotoCollection Delegate
extension DiscoveryViewController : PhotoCollectionDelegate {
    func fetchCompleted() {
        self.collectionView.reloadData()
    }
}

//Search Bar Delegates
extension DiscoveryViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, searchText.count > 1 {
            dropDown.hide()
            recentSearches.add(searchText)
            self.renderPhotoListings(searchText)
            dropDown.dataSource = recentSearches.searches
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        loadRecentSearches()
        dropDown.show()
        return true
    }
    
}
