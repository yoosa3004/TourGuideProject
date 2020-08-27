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
import Firebase
import YYBottomSheet

class AccountViewController: UIViewController {
    
    var scvAccount = UIScrollView()
    
    var lbID = UILabel()
    
    var tfID = UITextField()
    
    var tfPassword = UITextField()
    
    var ivAccount = UIImageView()
    
    var btnLogin = UIButton()
    
    var btnSignin = UIButton()
    
    let notificationHelper = NotificationHelper()
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.white
        setFrameView()
        setViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 제스처 등록
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapScreenForHidingKeyboard)).then {
            $0.numberOfTouchesRequired = 1
        }
        
        scvAccount.addGestureRecognizer(singleTapGestureRecognizer)
        
        // 로그인/로그아웃 상태에 따라 뷰 업데이트
        let isLoggedIn = Auth.auth().currentUser != nil
        updateViewsPerAuthState(isLoggedIn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.title = "계정정보"
        
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
            $0.left.right.top.bottom.equalToSuperview()
        }
    }
    
    func setViews() {
        // 이미지
        self.scvAccount.addSubview(ivAccount)
        ivAccount.then {
            $0.image = UIImage(named: "heart_full")
            $0.contentMode = .scaleAspectFit
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(50)
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
            $0.delegate = self
            $0.returnKeyType = .next
            $0.autocapitalizationType = .none
            $0.keyboardType = .emailAddress
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
            $0.autocapitalizationType = .none
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
            
            Auth.auth().signIn(withEmail: email, password: password) { [unowned self] (user,error) in
                if let user = user {
                    String("로그인 성공!").showToast()
                    self.updateViewsPerAuthState(true)
                    self.view.endEditing(true)
                    
                    // 찜리스트에 담아놨던 행사들의 Notification 추가
                    self.notificationHelper.addAllUserNotification(userid: user.user.uid)
                    
                } else {
                    String("로그인 실패!").showToast()
                }
            }
        }
        // 로그아웃
        else {
            do {
                try Auth.auth().signOut()
                String("로그아웃 성공!").showToast()
                self.updateViewsPerAuthState(false)
                
                // 찜리스트에 담아놨던 행사들의 Notification 해제
                self.notificationHelper.removeAllUserNotification()
                
            } catch _ as NSError {
                String("로그아웃 실패!").showToast()
            }
        }
    }
    
    @objc func onSigninBtnClicked(_ sender: UIButton) {
        let vcSignUp = UINavigationController(rootViewController: SignUpViewController()).then {
            $0.modalPresentationStyle = .fullScreen
        }
        self.navigationController?.present(vcSignUp, animated: true, completion: nil)
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
    
    // MARK: 로그인/로그아웃에 따라 textField, button 상태를 변경
    func updateViewsPerAuthState(_ isLoggedIn : Bool) {
        
        tfID.isHidden = isLoggedIn
        tfPassword.isHidden = isLoggedIn
        lbID.isHidden = !isLoggedIn
        btnSignin.isHidden = isLoggedIn
        
        // 로그인 체크
        if isLoggedIn {
            self.scvAccount.addSubview(self.lbID)
            lbID.then {
                $0.text = "계정 \n\n \(Auth.auth().currentUser?.email ?? String("계정을 불러오지 못했습니다."))"
                $0.textAlignment = .center
                $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
                $0.numberOfLines = 4
            }.snp.makeConstraints {
                $0.top.equalTo(ivAccount.snp.bottom).offset(50)
                $0.left.equalTo(self.view.safeAreaLayoutGuide).offset(25)
                $0.right.equalTo(self.view.safeAreaLayoutGuide).offset(-25)
            }
            
            btnLogin.setTitle("로그아웃", for: .normal)
        } else {
            tfID.text = ""
            tfPassword.text = ""
            tfID.placeholder = "이메일"
            tfPassword.placeholder = "비밀번호"
            btnLogin.setTitle("로그인", for: .normal)
        }
    }
    
    @objc func tapScreenForHidingKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
