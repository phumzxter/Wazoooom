//
//  CostomTextField.swift
//  P C Chandra Jewellers
//
//  Created by developer on 19/04/18.
//  Copyright © 2018 PCChandra. All rights reserved.
//

import UIKit
enum InputType {
    case text
    case dropDown
    case phone
    case pinCode
    case email
    case password
    case confirmPassword
    
}

protocol CostomTextFieldDelegate {
    func textFieldShouldChange(text:String,textFieldTag: Int)
    func textFieldDidBeginEditing(textFieldTag: Int)
    func textFieldDidEndEditing(textFieldTag: Int)

}
class CostomTextField: UIView {
    
    @IBOutlet weak var placeholderLabelTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var pinCodeTextField: UITextField!
    var passwordTextField: CostomTextField?
    var inputTYpe: InputType = .text
    var isPasswordShown: Bool = false
    var delegate: CostomTextFieldDelegate!
    func configureNib() -> UIView {
        let bundle = Bundle.init(for: type(of: self))
        let nib = UINib(nibName: "CostomTextField", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth , UIView.AutoresizingMask.flexibleHeight]
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = configureNib()
        self.addSubview(view)
        pinCodeTextField.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let view = configureNib()
        self.addSubview(view)
        pinCodeTextField.delegate = self
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.black.cgColor
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderColor = UIColor.black.cgColor

        //self.layer.borderColor = UIColor.init(hexString: "#9D8C80").cgColor
    }

    @IBAction func passwordShowHideButtonTapped(_ sender: UIButton) {
        if isPasswordShown {
            isPasswordShown = false
            pinCodeTextField.isSecureTextEntry = true
            self.passwordButton.setImage(UIImage.init(named: "passNotShown")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.passwordButton.tintColor = .white

        }
        else {
            isPasswordShown = true
            pinCodeTextField.isSecureTextEntry = false
            self.passwordButton.setImage(UIImage.init(named: "passShown")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.passwordButton.tintColor = .white


        }
    }
    
    func setText(string: String) {
        if string.count > 0 {
            self.pinCodeTextField.text = string
        }
    }
    
    func configView(inputType: InputType,placeholderText:String) {
        self.passwordButton.setImage(UIImage.init(named: "passNotShown")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.passwordButton.tintColor = .white
        self.placeHolderLabel.text = placeholderText
//        self.layer.borderWidth = 1.0
//        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        customView.layer.masksToBounds = true
        pinCodeTextField.delegate = self
        pinCodeTextField.isSecureTextEntry = false
        passwordButton.isHidden = true
        self.inputTYpe = inputType
        switch self.inputTYpe {
        case .text:
            pinCodeTextField.keyboardType = .asciiCapable
            break
        case .phone:
            pinCodeTextField.keyboardType = .phonePad
            break
        case .pinCode:
            pinCodeTextField.keyboardType = .decimalPad
            break
        case .dropDown:
            pinCodeTextField.keyboardType = .default
            break
        case .email:
            pinCodeTextField.keyboardType = .emailAddress
            break
        case .password:
            pinCodeTextField.keyboardType = .asciiCapable
            pinCodeTextField.isSecureTextEntry = true
            passwordButton.isHidden = false
            break
        case .confirmPassword:
            pinCodeTextField.keyboardType = .asciiCapable
            pinCodeTextField.isSecureTextEntry = true
            passwordButton.isHidden = false

            break
        }
        
        self.layoutSubviews()
    }
    
}

extension CostomTextField: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if inputTYpe == .confirmPassword {
            if let passwordField = self.passwordTextField {
                if passwordField.pinCodeTextField.text!.count > 0 {
                    return true
                }
                else {
                    return false
                }
            }
            
        }
        return true
    }
    
    @objc func textChanged(notification: NSNotification) {
        if delegate != nil {
            delegate.textFieldShouldChange(text: pinCodeTextField.text!, textFieldTag: self.tag)
        }

    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        placeholderLabelTopConstraints.constant = 0
        
        
        if delegate != nil {
            delegate.textFieldDidBeginEditing(textFieldTag: self.tag)
        }

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == 0 {
            
            placeHolderLabel.font = UIFont.init(name: "Dosis-Regular", size: 16)
            

        }
        if delegate != nil {
            delegate.textFieldDidEndEditing(textFieldTag: self.tag)
        }

    }

    func validateFields() -> (Bool,String) {
        switch inputTYpe {
        case .text:
            return validateText()
        case .phone:
            return validatePhone()
        case .pinCode:
            return validatePinCode()
        case .dropDown:
            return validateText()
        case .email:
            return validateEmail()
        case .password:
            return validatePassword()
        case .confirmPassword:
            return validateConfirmPassword()
        }
    }
    
    func validateText() -> (Bool,String) {
        if pinCodeTextField.text?.count == 0 {
            self.layer.borderColor = UIColor.init(hexString: "#000000").cgColor

            return (false,"No data")
        }
        self.layer.borderColor = UIColor.init(hexString: "#9D8C80").cgColor

        return (true,"Valid")
    }
    
    
    func validatePassword() -> (Bool,String){
        if pinCodeTextField.text?.count == 0 {
            self.layer.borderColor = UIColor.init(hexString: "#FF1513").cgColor

            return (false,"Password field cannot be empty.")
        }
        self.layer.borderColor = UIColor.init(hexString: "#9D8C80").cgColor

        return (true,"Valid")
    }
    
    func validateConfirmPassword() -> (Bool,String){
        if pinCodeTextField.text?.count == 0 {
            self.layer.borderColor = UIColor.init(hexString: "#FF1513").cgColor

            return (false,"Confirm Password field cannot be empty.")
        }
        else {
            if let passwordField = self.passwordTextField {
                if passwordField.pinCodeTextField.text == pinCodeTextField.text {
                    self.layer.borderColor = UIColor.init(hexString: "#9D8C80").cgColor

                    return (true,"Valid")
                }
                else {
                    self.layer.borderColor = UIColor.init(hexString: "#FF1513").cgColor

                    return (false,"Password mismatch")
                }
            }
            else {
                self.layer.borderColor = UIColor.init(hexString: "#FF1513").cgColor

                return (false,"Password field cannot be validated")
            }
        }
    }
    
    
    func validateEmail() -> (Bool,String) {
        if pinCodeTextField.text?.count == 0 {
            return (false,"Email field cannot be empty.")
        }
        else {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if emailTest.evaluate(with: self.pinCodeTextField.text) {
                self.layer.borderColor = UIColor.init(hexString: "#9D8C80").cgColor

                return (true,"Valid")
            }
            else {
                self.layer.borderColor = UIColor.init(hexString: "#FF1513").cgColor

                return (false,"Email not valid")
            }
        }
    }
    
    func validatePhone() -> (Bool,String) {
        if pinCodeTextField.text?.count == 0 {
            self.layer.borderColor = UIColor.init(hexString: "#FF1513").cgColor

            return (false,"Mobile number field cannot be empty.")
            
        }
        else {
            if pinCodeTextField.text?.count != 10 {
                self.layer.borderColor = UIColor.init(hexString: "#FF1513").cgColor

                return (false,"Mobile number not valid.")
                
            }
        }
        self.layer.borderColor = UIColor.init(hexString: "#9D8C80").cgColor

        return (true,"valid")
    }
    
    func validatePinCode() -> (Bool,String) {
        if pinCodeTextField.text?.count == 0 {
            self.layer.borderColor = UIColor.init(hexString: "#FF1513").cgColor

            return (false,"Pin Code field cannot be empty.")
        }
        else {
            if pinCodeTextField.text?.count != 6 {
                self.layer.borderColor = UIColor.init(hexString: "#FF1513").cgColor

                return (false,"Pin Code not valid")
                
            }
        }
        self.layer.borderColor = UIColor.init(hexString: "#9D8C80").cgColor

        return (true,"valid")
    }
    
    
    
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
    
    func hexStringFromColor() -> String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        print(hexString)
        return hexString
     }

    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
