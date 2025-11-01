//
//  Coordinator.swift
//  SF Users
//
//  Created by Monika Stoyanova on 1.11.25.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

final class AppCoordinator: Coordinator {
    
    private var viewModel: SFUserViewModelProtocol
    private let userListVC: SFUserListViewController
    
    var navigationController: UINavigationController
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        let repository = SFRepository()
        viewModel = SFUserViewModel(repository: repository)
        userListVC = SFUserListViewController(viewModel: viewModel)
        
        viewModel.shouldShowAlert = { [weak self]  in
            Task { @MainActor in
                self?.showAlert()
            }
        }
    }
    
    func start() {
        navigationController.setViewControllers([userListVC], animated: false)
    }
    
    // MARK: - Private
    private func showAlert() {
        let alert = UIAlertController(title: "Network issue",
                                      message: "Please try again later",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: { [weak alert] _ in
            alert?.dismiss(animated: true)
        }))
        userListVC.present(alert, animated: true)
    }
}
