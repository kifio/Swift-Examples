//
//  ViewController.swift
//  Passwords
//
//  Created by Ivan Murashov on 04/09/2018.
//  Copyright © 2018 Ivan Murashov. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    weak var login: UITextField!
    weak var password: UITextField!
    weak var loginButton: UIButton!
    weak var logoutButton: UIButton!
    weak var greetings: UILabel!
    weak var ctx: NSManagedObjectContext!
    
    override func loadView() {
        super.loadView()
        let app = UIApplication.shared.delegate as! AppDelegate
        ctx = app.persistentContainer.viewContext
        updateUI()
    }
    
    private func updateUI() {
        if let user = requestUser() {
            removeView(login)
            removeView(password)
            removeView(loginButton)
            buildGreetings(user: user)
            buildLogoutButton()
        } else {
            removeView(logoutButton)
            removeView(greetings)
            buildLoginTextField()
            buildPasswordTextField()
            buildLoginButton()
        }
    }
    
    private func removeView(_ view: UIView?) {
        if view != nil {
            view?.removeFromSuperview()
        }
    }
    
    private func buildLoginTextField() {
        let login = UITextField(frame: .zero)
        login.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(login)
        NSLayoutConstraint.activate(flexibleConstraints(view: login, aboveView: nil))
        login.placeholder = "Enter login"
        self.login = login
    }
    
    private func buildPasswordTextField() {
        let password = UITextField(frame: .zero)
        password.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(password)
        NSLayoutConstraint.activate(flexibleConstraints(view: password, aboveView: self.login))
        password.placeholder = "Enter password"
        self.password = password
    }
    
    private func buildLoginButton() {
        let loginButton = UIButton(frame: .zero)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loginButton)
        NSLayoutConstraint.activate(fixedWidthConstraints(view: loginButton, aboveView: self.password))
        loginButton.setTitle("Login", for: UIControlState.normal)
        loginButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        loginButton.addTarget(self, action: #selector(saveUser), for: UIControlEvents.touchUpInside)
        self.loginButton = loginButton
    }
    
    private func buildGreetings(user: NSManagedObject) {
        let username = user.value(forKey: "name")
        let greetings = UILabel(frame: .zero)
        greetings.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(greetings)
        NSLayoutConstraint.activate(flexibleConstraints(view: greetings, aboveView: nil))
        greetings.text = "Hello, \(username ?? "")"
        self.greetings = greetings
    }
    
    private func buildLogoutButton() {
        let logoutButton = UIButton(frame: .zero)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logoutButton)
        NSLayoutConstraint.activate(fixedWidthConstraints(view: logoutButton, aboveView: self.greetings))
        logoutButton.setTitle("Logout", for: UIControlState.normal)
        logoutButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        logoutButton.addTarget(self, action: #selector(removeUser), for: UIControlEvents.touchUpInside)
        self.logoutButton = logoutButton
    }
    
    private func fixedWidthConstraints(view: UIView, aboveView: UIView) -> Array<NSLayoutConstraint> {
        return [
            view.heightAnchor.constraint(equalToConstant: 64),
            view.widthAnchor.constraint(equalToConstant: 64),
            view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            view.topAnchor.constraint(equalTo: aboveView.bottomAnchor),
        ]
    }
    
    private func flexibleConstraints(view: UIView, aboveView: UIView?) -> Array<NSLayoutConstraint> {
        let horizontalConstraint: NSLayoutConstraint
        
        if aboveView != nil {
            horizontalConstraint = view.topAnchor.constraint(equalTo: aboveView!.bottomAnchor)
        } else {
            horizontalConstraint = view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        }
        
        return [
            view.heightAnchor.constraint(equalToConstant: 64),
            view.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            horizontalConstraint,
        ]
    }
    
    @objc private func saveUser() {
        if login.text != nil && password.text != nil {
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: ctx)
            newUser.setValue(login.text, forKey: "name")
            newUser.setValue(password.text, forKey: "password")
            save(ctx)
        }
    }
    
    @objc private func removeUser() {
        if let user = requestUser() {
            ctx.delete(user)
            save(ctx)
        }
    }
    
    private func requestUser() -> NSManagedObject? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let results = try ctx.fetch(request) as! [NSManagedObject]
            if results.count > 0 {
                return results[0]
            } else {
                return nil
            }
        } catch {
            print("No results")
            return nil
        }
    }
    
    private func requestUser(name: String) -> NSManagedObject? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = NSPredicate(format: "name = %@", name)
        request.returnsObjectsAsFaults = false
        do {
            let results = try ctx.fetch(request) as! [NSManagedObject]
            if results.count > 0 {
                return results[0]
            } else {
                return nil
            }
        } catch {
            print("No results")
            return nil
        }
    }
    
    private func save(_ ctx: NSManagedObjectContext) {
        do {
            try ctx.save()
            updateUI()
        } catch {
            print("Can't save user")
        }
    }
}

