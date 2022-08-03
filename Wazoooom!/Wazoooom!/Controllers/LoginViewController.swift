//
//  LoginViewController.swift
//  Wazoooom!
//
//  Created by Phumin Abdul Hameed on 01/04/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var passwordTextField: CostomTextField!
    @IBOutlet weak var userNameTextField: CostomTextField!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.configView(inputType: .text, placeholderText: "Username")
        passwordTextField.configView(inputType: .password, placeholderText: "Password")
        containerView.layer.cornerRadius = 30
        containerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]

        signinButton.layer.cornerRadius = 8
        signinButton.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    func validate() -> Bool {
        var flag: Bool = false
        let usenameVald = userNameTextField.validateFields()
        let passwordVald = passwordTextField.validateFields()

        if usenameVald.0 {
            flag = true
        }
        else {
            flag = false
        }
        if passwordVald.0 {
            flag = true
        }
        else {
            flag = false
        }

        return flag
    }

    @IBAction func signinButtonTapped(_ sender: Any) {
        if validate() {
            let user:[String:String] = ["userName":userNameTextField.pinCodeTextField.text!, "password":passwordTextField.pinCodeTextField.text!]
            Firebase.checkUserNameAndPassword(user: user) { (user, success, error) in
                if success {
                    UserDefaults.standard.setValue(user, forKey: "user")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tab")
                    UIApplication.shared.windows[0].rootViewController = vc
                    UIApplication.shared.windows[0].makeKeyAndVisible()

                }
                else {
                    if let errorText = user["text"] as? String {
                        self.view.makeToast(errorText)
                    }
                }
            }
        }
        
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
