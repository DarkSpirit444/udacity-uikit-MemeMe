//
//  MemeMeTextFieldDelegate.swift
//  Meme Me
//
//  Created by David Teo on 4/18/16.
//  Copyright © 2016 Compete Co-op Networks. All rights reserved.
//

import Foundation
import UIKit

class MemeMeTextFieldDelegate : NSObject, UITextFieldDelegate
{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
}
