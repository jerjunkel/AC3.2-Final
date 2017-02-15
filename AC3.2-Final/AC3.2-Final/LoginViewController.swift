//
//  LoginViewController.swift
//  AC3.2-Final
//
//  Created by Jermaine Kelly on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth

protocol LoginProtocol{
  
    var isLoggedIn: Bool {get set}
}

class LoginViewController: UIViewController {
    private var shouldRegister: Bool = false
    private var isLoggedIn: Bool = false
    var loginDelegate: LoginProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = .white
        
        setUpViews()
    }
    
    //MARK:- SetupViews
    func setUpViews(){
        
        self.edgesForExtendedLayout = []
        
        let padding: CGFloat = 40
        
        self.view.addSubview(loginLogo)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerLabel)
        self.view.addSubview(registerButton)
        
        loginLogo.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.top.equalToSuperview().offset(padding)
        }
        
        emailTextField.snp.makeConstraints { (view) in
            view.top.equalTo(self.loginLogo.snp.bottom).offset(50)
            view.centerX.equalToSuperview()
            view.width.equalToSuperview().multipliedBy(0.7)
        }
        
        passwordTextField.snp.makeConstraints { (view) in
            view.top.equalTo(self.emailTextField.snp.bottom).offset(padding)
            view.centerX.equalToSuperview()
            view.width.equalToSuperview().multipliedBy(0.7)
        }
        
        loginButton.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.top.equalTo(self.passwordTextField.snp.bottom).offset(padding)
        }
        
        registerLabel.snp.makeConstraints { (view) in
            view.top.equalTo(loginButton.snp.bottom)
            view.centerX.equalToSuperview()
        }
        
        registerButton.snp.makeConstraints { (view) in
            view.top.equalTo(registerLabel.snp.bottom)
            view.centerX.equalToSuperview()
        }
        
        loginButton.addTarget(self, action: #selector(fireBaseLogin), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(fireBaseRegister), for: .touchUpInside)
    }
    
    //MARK:- Utilities
    func fireBaseLogin(){
        
        if let email = emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces),
            let password =  passwordTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces){
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
                
                if error != nil{
                    self.showAlert(title: "Login Failed", message: error?.localizedDescription ?? "")
                }
                
                if user != nil{
                    self.showAlert(title: "Login Successful", message: "Welcome!!", handler: { (_) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                    self.loginDelegate?.isLoggedIn = true
                }
            })
        }else{
            showAlert(title: "Login Failed", message: "Check username and password")
        }
    }
    
    func fireBaseRegister(){
        
        if let email = emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces),
            let password =  passwordTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces){
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
                
                if error != nil{
                    self.showAlert(title: "Register Failed", message: error?.localizedDescription ?? "")
                }
                
                if user != nil{
                    self.showAlert(title: "Register Succesful", handler: { (_) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    self.loginDelegate?.isLoggedIn = true
                }
            })
        }else{
            showAlert(title: "Login Failed", message: "Check username and password")
        }
    }
    
    private func showAlert(title: String, message: String = "", handler: ((UIAlertAction) -> Void)? = nil){
        let alert :UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Views
    private let loginLogo: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "meatly_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailTextField: UITextField = {
        let textfield: UITextField = UITextField()
        textfield.placeholder = "Email..."
        textfield.backgroundColor = UIColor.lightGray
        textfield.keyboardType = .emailAddress
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        return textfield
    }()
    
    private let passwordTextField: UITextField = {
        let textfield: UITextField = UITextField()
        textfield.placeholder = "Password..."
        textfield.backgroundColor = UIColor.lightGray
        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    private let loginButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    private let registerButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("click here", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
        
    }()
    
    private let registerLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Don't have an account?"
        return label
    }()
}
