//
//  SignupViewController.swift
//  Wazoooom!
//
//  Created by Phumin Abdul Hameed on 01/04/21.
//

import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: CostomTextField!
    @IBOutlet weak var userNameTextField: CostomTextField!
    @IBOutlet weak var emailTextField: CostomTextField!
    @IBOutlet weak var fullNameTextField: CostomTextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var signinButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.configView(inputType: .text, placeholderText: "Username")
        passwordTextField.configView(inputType: .password, placeholderText: "Password")
        emailTextField.configView(inputType: .email, placeholderText: "Email")
        fullNameTextField.configView(inputType: .text, placeholderText: "Full Name")
        containerView.layer.cornerRadius = 30
        containerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        signinButton.layer.cornerRadius = 8
        signinButton.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    func validate() -> Bool {
        var flag: Bool = false
        let usenameVald = userNameTextField.validateFields()
        let emailVald = emailTextField.validateFields()
        let nameVald = fullNameTextField.validateFields()
        let passwordVald = passwordTextField.validateFields()

        if usenameVald.0 {
            flag = true
        }
        else {
            self.view.makeToast(usenameVald.1)

            flag = false
        }
        
        if emailVald.0 {
            flag = true
        }
        else {
            self.view.makeToast(emailVald.1)

            flag = false
        }

        if nameVald.0 {
            flag = true
        }
        else {
            self.view.makeToast(nameVald.1)

            flag = false
        }

        if passwordVald.0 {
            flag = true
        }
        else {
            self.view.makeToast(passwordVald.1)

            flag = false
        }

        return flag
    }

    
    @IBAction func signupButtonTapped(_ sender: Any) {
        if validate() {
            let uuid = UUID().uuidString

            let user:[String:String] = ["userId":uuid,"userName":userNameTextField.pinCodeTextField.text!, "email":emailTextField.pinCodeTextField.text!, "password":passwordTextField.pinCodeTextField.text!, "fullName":fullNameTextField.pinCodeTextField.text!]
            
            Firebase.storeUser(user: user) { (success, error) in
                if success {
                    UserDefaults.standard.setValue(user, forKey: "user")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tab")
                    UIApplication.shared.windows[0].rootViewController = vc
                    UIApplication.shared.windows[0].makeKeyAndVisible()
                }
                else {
                    self.view.makeToast("Username already exist.")

                }
            }

        }
    }
    @IBAction func loginButtonTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
