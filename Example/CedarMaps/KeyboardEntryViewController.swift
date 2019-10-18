//
//  KeyboardEntryViewController.swift
//
//  Created by Saeed Taheri on 2016/2/6.
//  Copyright © 2016 Cedar. All rights reserved.
//

import UIKit

class KeyboardEntryViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    var mainScrollView: UIScrollView! { //Subclasses should set this immediately
        didSet {
            mainScrollView.keyboardDismissMode = .interactive
            if !(mainScrollView is UITextView) {
                let tapToDismissGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
                tapToDismissGestureRecognizer.numberOfTapsRequired = 1
                tapToDismissGestureRecognizer.cancelsTouchesInView = true
                mainScrollView.addGestureRecognizer(tapToDismissGestureRecognizer)
            }
        }
    }
    
    private var _keyboardHeight: CGFloat = 0
    var keyboardHeight: CGFloat {
        return _keyboardHeight
    }
    
    private var activeTextField: UITextField? //Subclasses should be delegate of all their text fields
    private var activeTextView: UITextView?
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        activeTextView = nil
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextView = textView
        activeTextField = nil
    }
    
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        if let window = UIApplication.shared.keyWindow {
            window.endEditing(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardDidShow(_ notification: Foundation.Notification) {
        if let userInfo = (notification as NSNotification).userInfo {
            if let notificationValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                
                let keyboardFrame = notificationValue.cgRectValue
                _keyboardHeight = keyboardFrame.size.height
                
                let scrollViewRectInWindow = mainScrollView.convert(mainScrollView.bounds, to: nil)
                
                if scrollViewRectInWindow.origin.y + scrollViewRectInWindow.size.height < keyboardFrame.origin.y {
                    mainScrollView.contentInset = UIEdgeInsets(top: mainScrollView.contentInset.top, left: mainScrollView.contentInset.left, bottom: 0, right: mainScrollView.contentInset.right)
                    mainScrollView.scrollIndicatorInsets = mainScrollView.contentInset
                    
                    return
                }
                
                mainScrollView.contentInset = UIEdgeInsets(top: mainScrollView.contentInset.top, left: mainScrollView.contentInset.left, bottom: mainScrollView.frame.size.height - keyboardFrame.origin.y + scrollViewRectInWindow.origin.y, right: mainScrollView.contentInset.right)
                mainScrollView.scrollIndicatorInsets = mainScrollView.contentInset
                
                if let activeTextField = activeTextField {
                    let textfieldRectInWindow = activeTextField.convert(activeTextField.bounds, to: nil)
                    
                    if (textfieldRectInWindow.origin.y + textfieldRectInWindow.size.height + 8.0 > keyboardFrame.origin.y) {
                        DispatchQueue.main.async {
                            var textFieldRectInScrollView = activeTextField.convert(activeTextField.bounds, to: self.mainScrollView)
                            textFieldRectInScrollView.origin.y += 8.0
                            self.mainScrollView.scrollRectToVisible(textFieldRectInScrollView, animated: true)
                        }
                    }
                } else if let activeTextView = activeTextView {
                    let textViewRectInWindow = activeTextView.convert(activeTextView.bounds, to: nil)
                    
                    if (textViewRectInWindow.origin.y + 20.0 + 8.0 > keyboardFrame.origin.y) {
                        DispatchQueue.main.async {
                            var textViewRectInScrollView = activeTextView.convert(activeTextView.bounds, to: self.mainScrollView)
                            if activeTextView != self.mainScrollView {
                                textViewRectInScrollView.origin.y += 8.0
                                self.mainScrollView.scrollRectToVisible(textViewRectInScrollView, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Foundation.Notification) {
        _keyboardHeight = 0
        mainScrollView.contentInset = UIEdgeInsets(top: mainScrollView.contentInset.top, left: mainScrollView.contentInset.left, bottom: 0, right: mainScrollView.contentInset.right)
        mainScrollView.scrollIndicatorInsets = mainScrollView.contentInset
    }

}
