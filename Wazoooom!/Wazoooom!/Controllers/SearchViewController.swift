//
//  SearchViewController.swift
//  Wazoooom!
//
//  Created by Phumin Abdul Hameed on 01/04/21.
//

import UIKit
import SDWebImage

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items: [[String:String]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        // Do any additional setup after loading the view.
    }
    

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        WebService.getSearchImages(query: searchBar.text!) { (result, success, error) in
            self.items = result
            self.collectionView.reloadData()
        }

    }

}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize.init(width: UIScreen.main.bounds.width/2 - 40, height: UIScreen.main.bounds.width/2 - 40)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
        let urlInString = items[indexPath.row]["small"]
        cell.searchedImageView.sd_setImage(with: URL.init(string: urlInString!), placeholderImage: UIImage.init(named: "placeholder"))
        cell.searchedImageView.layer.cornerRadius = 10
        cell.searchedImageView.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let urlInString = items[indexPath.row]["regular"]
        let imageView = UIImageView.init()
        imageView.sd_setImage(with: URL.init(string: urlInString!)) { (image, error, type, url) in
            let activityController = UIActivityViewController.init(activityItems: [image!], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)

        }
    }
}
