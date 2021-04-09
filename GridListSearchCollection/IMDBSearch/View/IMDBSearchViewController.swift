//
//  IMDBSearchViewController.swift
//  GridListSearchCollection
//
//  Created by Ankit Thakur on 09/04/21.
//

import Foundation
import UIKit

struct GridConfiguration {
    static let itemsPerRow: CGFloat = 3
    static let sectionInsets = UIEdgeInsets(
        top: 50.0,
        left: 20.0,
        bottom: 50.0,
        right: 20.0)
}

struct ListConfiguration {
    static let itemsPerRow: CGFloat = 1
    static let sectionInsets = UIEdgeInsets(
        top: 10.0,
        left: 10.0,
        bottom: 10.0,
        right: 10.0)
}

enum ViewConfigurationType {
    case grid
    case list
}
class IMDBSearchViewController: UIViewController {
    
    var presenter: IMDBSearchViewToPresenterProtocol!
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    var searchBarController: UISearchController?
    var searchString: String?
    var viewConfigurationType: ViewConfigurationType = .grid
    var isSearchCancelled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        let barButtonItem = UIBarButtonItem(image: R.image.gridIcon(), style: .plain, target: self, action: #selector(changeViewLayoutAction))
        self.navigationItem.rightBarButtonItem = barButtonItem
                                            
        self.search()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
    }
    
    func search(withIncrementalPage: Bool = false) {
        presenter.fetchMovies(for: self.searchString, withIncrementalPage: withIncrementalPage)
    }
    
    @objc func changeViewLayoutAction() {
        self.viewConfigurationType = self.viewConfigurationType == .grid ? .list : .grid
        self.navigationItem.rightBarButtonItem?.image = self.viewConfigurationType == .grid ? R.image.gridIcon() : R.image.listIcon()
        self.moviesCollectionView.reloadData()
    }
}

// MARK: - IMDBSearchPresenterToViewProtocol
extension IMDBSearchViewController: IMDBSearchPresenterToViewProtocol {
    
    func initializeView() {
        searchBarController = UISearchController(searchResultsController: nil)
        searchBarController!.searchBar.autocapitalizationType = .none
        searchBarController!.obscuresBackgroundDuringPresentation = false
        searchBarController?.searchResultsUpdater = self
        searchBarController?.searchBar.delegate = self
        /** Specify that this view controller determines how the search controller is presented.
         The search controller should be presented modally and match the physical size of this view controller.
         */
        definesPresentationContext = true
        
        self.navigationItem.searchController = searchBarController
        self.searchBarController?.isActive = false
        
        self.moviesCollectionView.delegate = self
        self.moviesCollectionView.dataSource = self
        
        self.moviesCollectionView.register(UINib(resource: R.nib.gridMovieCollectionViewCell),
                                           forCellWithReuseIdentifier: R.nib.gridMovieCollectionViewCell.identifier)
        self.moviesCollectionView.register(UINib(resource: R.nib.listMovieCollectionViewCell),
                                           forCellWithReuseIdentifier: R.nib.listMovieCollectionViewCell.identifier)
        
    }
    
    func reloadMovies() {
        self.emptyView.isHidden = true
        self.moviesCollectionView.isHidden = false
        self.moviesCollectionView.reloadData()
    }
    
    func showNoMoviesReceived() {
        self.emptyView.isHidden = false
        self.moviesCollectionView.isHidden = true
        self.emptyLabel.text = (searchString ?? "").isEmpty ? "No movies!!" : "No movies found!!"
    }
}

extension IMDBSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard presenter.canLoadMore(at: indexPath) else {return}
        self.search(withIncrementalPage: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var movieCell: GridMovieCollectionViewCell?
        if viewConfigurationType == .grid {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.gridMovieCollectionViewCell.identifier, for: indexPath) as? GridMovieCollectionViewCell else {return UICollectionViewCell()}
            movieCell = cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.listMovieCollectionViewCell.identifier, for: indexPath) as? GridMovieCollectionViewCell  else {return UICollectionViewCell()}
            movieCell = cell
        }
        guard movieCell != nil,
              let movie = presenter.movie(at: indexPath) else {return UICollectionViewCell()}
        
        movieCell!.loadMovie(movie)
        return movieCell!
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItemsInSection(section)
    }
}

extension IMDBSearchViewController: UICollectionViewDelegateFlowLayout {
    // 1
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         
        guard viewConfigurationType == .grid else {
            let paddingSpace = ListConfiguration.sectionInsets.left * (ListConfiguration.itemsPerRow + 1)
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / ListConfiguration.itemsPerRow
            
            return CGSize(width: widthPerItem, height: 50)
            
        }
        let paddingSpace = GridConfiguration.sectionInsets.left * (GridConfiguration.itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / GridConfiguration.itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return viewConfigurationType == .grid ? GridConfiguration.sectionInsets : ListConfiguration.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewConfigurationType == .grid ? GridConfiguration.sectionInsets.left : ListConfiguration.sectionInsets.left
    }
}

extension IMDBSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard !isSearchCancelled else {return}
            
        if let searchText = searchController.searchBar.text {
            searchString = searchText
            self.search()
        }
    }
}

extension IMDBSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchCancelled = true
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchCancelled = false
    }
}
