import UIKit

extension ViewController: UITextFieldDelegate, UITextViewDelegate {
    //MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField = textField
        activeTextView = nil
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeTextField?.resignFirstResponder()
        activeTextField = nil
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
    
    //MARK: - UITextViewDelegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        activeTextView = textView
        activeTextField = nil
        return true
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    }
    
    
    @objc func returnTextView(gesture: UIGestureRecognizer) {
        if (activeTextField != nil) {
        
            activeTextField?.resignFirstResponder()
            activeTextField = nil
            return
        }
        if (activeTextView != nil) {
        
            activeTextView?.resignFirstResponder()
            activeTextView = nil
        }
    }
}

// MARK: Keyboard Handling
extension ViewController {
    
    func setupKeyboard() {
        // Observe keyboard change

    }
    
    
    func registerForKeyboardNotifications(){
        
        // Add touch gesture for contentView
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
        
        
        let contentWidth = scrollViewOutlet.bounds.width
        let contentHeight = scrollViewOutlet.bounds.height * 3
        scrollViewOutlet.contentSize = CGSize(width: contentWidth, height: contentHeight)

        //Adding notifies on keyboard appearing
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        
        firstOutlet.delegate = self
        secondOutlet.delegate = self
     
        
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
            
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {

          // if keyboard size is not available for some reason, dont do anything
          return
        }
        keyboardHeight = keyboardSize.height
        
        var shouldMoveViewUp = false

        // if active text field is not nil
        if let activeTextField = activeTextField {
            print("activeTextField")
          let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
          
          let topOfKeyboard = scrollViewOutlet.frame.height - keyboardSize.height

          // if the bottom of Textfield is below the top of keyboard, move up
          if bottomOfTextField > topOfKeyboard {
            shouldMoveViewUp = true
          }
        }
        
        if let activeTextView = activeTextView {
            let bottomOfTextField = activeTextView.convert(activeTextView.bounds, to: self.view).maxY;
                     
             let topOfKeyboard = scrollViewOutlet.frame.height - keyboardSize.height

             // if the bottom of Textfield is below the top of keyboard, move up
             if bottomOfTextField > topOfKeyboard {
               shouldMoveViewUp = true
             }
        }

        print("shouldMoveViewUp: \(shouldMoveViewUp)")
        if(shouldMoveViewUp) {
            //scrollView.frame.origin.y = 0 - keyboardSize.height
            
         
            if let  activeTextField = activeTextField {
                var point = activeTextField.frame.origin
                point.x = 0
                scrollViewOutlet.contentOffset = point
            }
            /*
            if activeTextView != nil {
                var point = notesLabelOutlet.frame.origin
                point.x = 0
                scrollViewOutlet.contentOffset = point
            }
            */
        }
        self.constraintContentHeightScrollView.constant -= self.keyboardHeight
        self.scrollViewOutlet.layoutIfNeeded()
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      //scrollView.frame.origin.y = 0
        self.constraintContentHeightScrollView.constant += self.keyboardHeight
       self.scrollViewOutlet.layoutIfNeeded()
    }

  
}
