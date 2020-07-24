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

    var tfID = UITextField()
    
    var tfPassword = UITextField()
    
    var ivAccount = UIImageView()
    
    var btnLogin = UIButton()
    
    var btnSignin = UIButton()
    
    override func loadView() {
        super.loadView()
      
        self.view.backgroundColor = UIColor.white
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.title = "계정정보"
    }
    
    func setUpView(){
        
        // 아이디
        self.view.addSubview(tfID)
        tfID.then { [unowned self] in
            $0.placeholder = "아이디"
            $0.textAlignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textAlignment = .left
            $0.layer.borderWidth = 1.0
            $0.borderStyle = .roundedRect
            $0.layer.borderColor = CGColor(srgbRed: 255, green: 192, blue: 203, alpha: 0)
            $0.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/5, height: self.view.frame.height/5)
            $0.autocorrectionType = .no
        }.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        // 비밀번호
        self.view.addSubview(tfPassword)
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
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.tfID.snp.bottom).offset(20)
            $0.left.right.equalTo(self.tfID)
        }
        
        // 이미지
        self.view.addSubview(ivAccount)
        ivAccount.then {
            $0.image = UIImage(named: "heart_full.png")
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(70)
            $0.centerX.equalToSuperview()
        }
        
        // 로그인 버튼
        self.view.addSubview(btnLogin)
        btnLogin.then { [unowned self] in
            $0.backgroundColor = .lightGray
            $0.setTitle("로그인", for: .normal)
            $0.addTarget(self, action: #selector(onLoginBtnClicked(_:)), for: UIControl.Event.touchUpInside)
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.tfPassword.snp.bottom).offset(20)
            $0.left.right.equalTo(self.tfID)
        }
        
        // 회원가입 버튼
         self.view.addSubview(btnSignin)
         btnSignin.then { [unowned self] in
            $0.backgroundColor = .lightGray
            $0.setTitle("회원가입", for: .normal)
            $0.addTarget(self, action: #selector(onSigninBtnClicked(_:)), for: UIControl.Event.touchUpInside)
         }.snp.makeConstraints { [unowned self] in
             $0.top.equalTo(self.btnLogin.snp.bottom).offset(15)
             $0.left.right.equalTo(self.tfID)
         }
    }
    
    @objc func onLoginBtnClicked(_ sender: UIButton) {
        
        // 로그인
        if sender.title(for: .normal) == "로그인" {
            
            guard let email = tfID.text, let password = tfPassword.text else { return }
            
            Auth.auth().signIn(withEmail: email, password: password) { (user,error) in
                if user != nil {
                    print("로그인 성공")
                    sender.setTitle("로그아웃", for: .normal)
                } else {
                    print("로그인 실패")
                }
            }
        }
        // 로그아웃
        else {
            do {
                try Auth.auth().signOut()
                sender.setTitle("로그인", for: .normal)
                print("로그아웃 성공")
            } catch _ as NSError {
                print("로그아웃 오류")
            }
        }
    }
    
    // 회원가입 버튼 이벤트
    @objc func onSigninBtnClicked(_ sender: UIButton) {
        
        guard let email = tfID.text, let password = tfPassword.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user
                else {
                    print("잘못된 형식 or 이미 있는 계정이라는 alert 필요")
                    return
            }
            
            if error == nil {
                print("회원 가입 완료")
            } else {
                print("회원 가입 실패")
                return
            }
        }
    }
}
