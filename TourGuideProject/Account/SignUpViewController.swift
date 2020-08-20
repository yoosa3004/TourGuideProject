//
//  SignUpViewController.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/31.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import YYBottomSheet
import FirebaseAuth
import FirebaseFirestore


class SignUpViewController: UIViewController {
    
    var scvAccount = UIScrollView()
    
    var tfID = UITextField()
    
    var tfPassword = UITextField()
    
    var ivAccount = UIImageView()
    
    var btnLogin = UIButton()
    
    var btnSignin = UIButton()

    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = .systemGray6
        
        setFrameView()
        setContentView()
        setNavItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 제스처 등록
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapScreenForHidingKeyboard)).then {
            $0.numberOfTouchesRequired = 1
            $0.isEnabled = true
            $0.cancelsTouchesInView = false
        }
        
        scvAccount.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "회원가입"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setFrameView() {
        // 스크롤뷰
        self.view.addSubview(scvAccount)
        scvAccount.then {
            $0.isScrollEnabled = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { [unowned self] in
            $0.left.right.equalToSuperview()
            $0.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    func setContentView(){
        
        // 이미지
        self.scvAccount.addSubview(ivAccount)
        ivAccount.then {
            $0.image = UIImage(named: "sign_up.png")
            $0.contentMode = .scaleAspectFit
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(100)
            $0.left.right.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        // 아이디
        self.scvAccount.addSubview(tfID)
        tfID.then { [unowned self] in
            $0.placeholder = "이메일"
            $0.textAlignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textAlignment = .left
            $0.layer.borderWidth = 1.0
            $0.borderStyle = .roundedRect
            $0.layer.borderColor = CGColor(srgbRed: 255, green: 192, blue: 203, alpha: 0)
            $0.autocorrectionType = .no
            $0.keyboardType = .emailAddress
            $0.autocapitalizationType = .none
            $0.delegate = self
            $0.returnKeyType = .next
        }.snp.makeConstraints {
            $0.top.equalTo(ivAccount.snp.bottom).offset(50)
            $0.left.equalTo(self.view.safeAreaLayoutGuide).offset(25)
            $0.right.equalTo(self.view.safeAreaLayoutGuide).offset(-25)
        }
        
        // 비밀번호
        self.scvAccount.addSubview(tfPassword)
        tfPassword.then { [unowned self] in
            $0.placeholder = "비밀번호"
            $0.textAlignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.borderStyle = .roundedRect
            $0.textAlignment = .left
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = CGColor(srgbRed: 255, green: 192, blue: 203, alpha: 0)
            $0.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/5, height: self.view.frame.height/5)
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.isSecureTextEntry = true
            $0.delegate = self
            $0.returnKeyType = .done
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.tfID.snp.bottom).offset(10)
            $0.left.right.equalTo(self.tfID)
        }
        
        // 회원가입 버튼
        self.scvAccount.addSubview(btnSignin)
        btnSignin.then { [unowned self] in
            $0.backgroundColor = .lightGray
            $0.setTitle("회원가입", for: .normal)
            $0.addTarget(self, action: #selector(onSigninBtnClicked(_:)), for: UIControl.Event.touchUpInside)
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.tfPassword.snp.bottom).offset(15)
            $0.left.right.equalTo(self.tfID)
            $0.bottom.equalToSuperview()
        }
    }
    
    @objc func onCloseBtnClicked(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func setNavItem() {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        self.view.addSubview(navBar)

        let navItem = UINavigationItem(title: "회원가입")
        navBar.setItems([navItem], animated: false)
        navItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(onCloseBtnClicked(_:)))
    }
    
    @objc func onSigninBtnClicked(_ sender: Any) {
        
        if let email = tfID.text, let password = tfPassword.text {
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                
                // 회원가입 성공!
                if error == nil {
                    self.completeSignUp()
                } else {
                    String("잘못된 이메일 형식이거나 이미 존재하는 계정입니다.").showToast()
                    return
                }
            }
        } else {
            String("잘못된 이메일 형식이거나 이미 존재하는 계정입니다.").showToast()
            return
        }
    }
    
    func completeSignUp() {
        presentingViewController?.dismiss(animated: true) {
            String("회원가입 완료!").showToast()
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == tfID {
            tfPassword.becomeFirstResponder()
        } else {
            tfPassword.resignFirstResponder()
        }
        
        return true
    }
    
    @objc func tapScreenForHidingKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        if self.view.frame.origin.y == 0.0 {
            self.view.frame.origin.y -= 50
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        if self.view.frame.origin.y < 0.0 {
            self.view.frame.origin.y += 50
        }
    }
}
