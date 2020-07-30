//
//  TGMyAccountViewController.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/09.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import SnapKit
import Then
import FirebaseAuth


class AccountViewController: UIViewController {
    
    var scvAccount = UIScrollView()
    
    var tfID = UITextField()
    
    var tfPassword = UITextField()
    
    var ivAccount = UIImageView()
    
    var btnLogin = UIButton()
    
    var btnSignin = UIButton()
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.white
        setFrameView()
        setUpView()
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
        
        self.tabBarController?.title = "계정정보"
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
    
    func setUpView(){
        
        // 이미지
        self.scvAccount.addSubview(ivAccount)
        ivAccount.then {
            $0.image = UIImage(named: "heart_full")
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
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
            $0.isSecureTextEntry = true
            $0.delegate = self
            $0.returnKeyType = .done
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.tfID.snp.bottom).offset(10)
            $0.left.right.equalTo(self.tfID)
        }
        // 로그인 버튼
        self.scvAccount.addSubview(btnLogin)
        btnLogin.then { [unowned self] in
            $0.backgroundColor = .lightGray
            $0.setTitle("로그인", for: .normal)
            $0.addTarget(self, action: #selector(onLoginBtnClicked(_:)), for: UIControl.Event.touchUpInside)
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.tfPassword.snp.bottom).offset(25)
            $0.left.right.equalTo(self.tfID)
        }
        
        // 회원가입 버튼
        self.scvAccount.addSubview(btnSignin)
        btnSignin.then { [unowned self] in
            $0.backgroundColor = .lightGray
            $0.setTitle("회원가입", for: .normal)
            $0.addTarget(self, action: #selector(onSigninBtnClicked(_:)), for: UIControl.Event.touchUpInside)
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.btnLogin.snp.bottom).offset(15)
            $0.left.right.equalTo(self.tfID)
            $0.bottom.equalToSuperview()
        }
    }
    
    @objc func onLoginBtnClicked(_ sender: UIButton) {
        
        // 로그인
        if sender.title(for: .normal) == "로그인" {
            
            guard let email = tfID.text, let password = tfPassword.text else { return }
            
            Auth.auth().signIn(withEmail: email, password: password) { (user,error) in
                if user != nil {
                    self.presentUserAlert(message: "로그인 성공!")
                    sender.setTitle("로그아웃", for: .normal)
                } else {
                    self.presentUserAlert(message: "로그인 실패!")
                }
            }
        }
            // 로그아웃
        else {
            do {
                try Auth.auth().signOut()
                self.presentUserAlert(message: "로그아웃 성공!")
                sender.setTitle("로그인", for: .normal)
            } catch _ as NSError {
                self.presentUserAlert(message: "로그아웃 실패!")
            }
        }
    }
    
    // 회원가입 버튼 이벤트
    @objc func onSigninBtnClicked(_ sender: UIButton) {
        
        guard let email = tfID.text, let password = tfPassword.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else {
                self.presentUserAlert(message: "잘못된 형식의 이메일이거나 이미 존재하는 계정입니다.")
                return
            }
            
            if error == nil {
                self.presentUserAlert(message: "회원가입 완료!")
            } else {
                self.presentUserAlert(message: "회원가입 실패!")
                return
            }
        }
    }
    
    func presentUserAlert(message: String?) {
        // alert
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
    
    @objc func tapScreenForHidingKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

extension AccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == tfID {
            tfPassword.becomeFirstResponder()
        } else {
            tfPassword.resignFirstResponder()
        }
        
        return true
    }
}
