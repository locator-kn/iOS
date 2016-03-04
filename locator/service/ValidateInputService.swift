//
//  ValidateInputService.swift
//  locator
//
//  Created by Sergej Birklin on 13/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import Foundation

public class ValidateInputService {
    
    let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    
    // Custom passwordRegEx http://stackoverflow.com/questions/5142103/regex-for-password-strength
    //let passwordRegEx = "^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$"
    
    let passwordRegEx = "^(*).{4}$"
    
    func checkEmailInput(email: String) -> Bool {
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(email)
    }
    
    func checkPasswordInput(password: String) -> Bool {
        if password.characters.count < 4 {
            return false
        } else {
            return true
        }
    }
    
    func checkInput(input: String, minLength: Int) -> Bool {
        if input.characters.count >= minLength {
            return true
        } else {
            return false
        }
    }
    
}