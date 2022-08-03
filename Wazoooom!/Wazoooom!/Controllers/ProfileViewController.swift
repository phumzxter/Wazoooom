//
//  ProfileViewController.swift
//  Wazoooom!
//
//  Created by Phumin Abdul Hameed on 03/04/21.
//

import UIKit
import FirebaseUI

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionaView: UICollectionView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var userFullNameLabel: UILabel!
    var items: [String] = []
    
    let storage = Storage.storage()

    override func viewDidLoad() {
        super.viewDidLoad()
        uploadButton.layer.cornerRadius = 8
        uploadButton.clipsToBounds = true

        let user = UserDefaults.standard.value(forKey: "user") as! [String:Any]
        userFullNameLabel.text = user["fullName"] as? String
        self.collectionaView.dataSource = self
        self.collectionaView.delegate = self
        if let items = user["images"] as? [String] {
            self.items = items
            self.collectionaView.reloadData()
        }
        let userId = user["userId"] as! String

        Firebase.getImages(userId: userId) { (items, success, error) in
            if success {
                self.items = items
                self.collectionaView.reloadData()
            }
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "user")
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "nav")
        UIApplication.shared.windows[0].rootViewController = vc
        UIApplication.shared.windows[0].makeKeyAndVisible()
    }
    
    @IBAction func uploadButtonTapped(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = false
        vc.delegate = self
        present(vc, animated: true)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        
        let data = image.pngData()
        let user = UserDefaults.standard.value(forKey: "user") as! [String:Any]
        let userId = user["userId"] as! String
        
        Firebase.uploadPhoto(data: data!, userId: userId) { (success, error) in
            Firebase.getImages(userId: userId) { (items, success, error) in
                if success {
                    self.items = items
                    self.collectionaView.reloadData()
                    }
                }
            
        } currentProgress: { (progress) in
            print(progress)
        }
        print(image.size)
    }
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        let urlInString = items[indexPath.row]
        let storageRef = storage.reference()

        let reference = storageRef.child(urlInString)
        let activityIndicator = UIActivityIndicatorView.init(style: .medium)
        activityIndicator.frame = CGRect.init(x: cell.searchedImageView.frame.size.width/2 - 20, y: cell.searchedImageView.frame.size.height/2 - 20, width: 40, height: 40)
        cell.searchedImageView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        reference.getData(maxSize: 40 * 1024 * 1024 * 1024) { (data, error) in
            activityIndicator.removeFromSuperview()

            if let error = error {
                print(error)
            }
            else {
                cell.searchedImageView.image = UIImage.init(data: data!)
            }
        }
        
        cell.searchedImageView.layer.cornerRadius = 10
        cell.searchedImageView.clipsToBounds = true
        return cell
    }
}
