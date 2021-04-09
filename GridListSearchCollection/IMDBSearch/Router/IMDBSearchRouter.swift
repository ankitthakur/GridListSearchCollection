//
//  IMDBSearchRouter.swift
//  GridListSearchCollection
//
//  Created by Ankit Thakur on 09/04/21.
//

import Foundation
import UIKit

class IMDBSearchRouter {
    
    var navigationViewController: UINavigationController?
    func build() {
        
        guard let navigationController = R.storyboard.imdbSearch.imdbSearchNavigationViewController(),
              let view = R.storyboard.imdbSearch.imdbSearchViewController() else {return}
        self.navigationViewController = navigationController
        
        let interactor = IMDBSearchInteractor()
        let presenter = IMDBSearchPresenter(view: view, interactor: interactor, router: self)
        interactor.presenter = presenter
        view.presenter = presenter
        self.navigationViewController?.viewControllers = [view]
    }
}

extension IMDBSearchRouter: IMDBSearchPresenterToRouterProtocol {
    
    func showNoInternetAvailable(in navigationController: UINavigationController) {
        let alert = UIAlertController(title: "No Internet available",
                                      message: "",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
        }))
        navigationController.present(alert, animated: true, completion: nil)
    }
}
