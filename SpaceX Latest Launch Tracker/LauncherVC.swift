//
//  ViewController.swift
//  SpaceX Latest Launch Tracker
//
//  Created by BerkH on 2.10.2023.
//

import UIKit
import AlamofireImage
import Shared

class LauncherVC: UIViewController {
    
    @IBOutlet weak var LauncherCollectionView: UICollectionView!
    
    var launchers: [LauncherResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshData()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        LauncherCollectionView.refreshControl = refreshControl
        
        
    }
    
    @objc func refreshData() {
        launchers.removeAll()
        LauncherServices.fetchLatestLauncher { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let launcher):
                    self.launchers.append(launcher)
                    self.LauncherCollectionView.reloadData()
                    Launcher.shared.launchers = self.launchers
                    print(self.launchers)
                case .failure(let error):
                    print("Veri alınamadı. Hata: \(error)")
                }
                
                self.LauncherCollectionView.refreshControl?.endRefreshing()
            }
        }
    }
    
    @objc func detailsTapped(_ sender: UITapGestureRecognizer) {
        if let label = sender.view as? UILabel, let details = label.text {
            showDetailsPopup(details: details)
        }
    }
    
    func showDetailsPopup(details: String) {
        let alertController = UIAlertController(title: "Details", message: details, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}

extension LauncherVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return launchers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "launcherCell", for: indexPath) as! LauncherCVC
        
        let launcher = launchers[indexPath.row]
        cell.lblName.text = launcher.name
        
        if let details = launcher.details {
            cell.lblDetails.text = details
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(detailsTapped(_:)))
            cell.lblDetails.isUserInteractionEnabled = true
            cell.lblDetails.addGestureRecognizer(tapGestureRecognizer)
        } else {
            cell.lblDetails.text = "Details are not defined."
        }
        
        if let imageURL = URL(string: launcher.links.patch.large) {
            cell.imgPatch.af.setImage(withURL: imageURL)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
