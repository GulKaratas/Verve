//
//  NewProductController.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import UIKit


protocol addProductDelegate: AnyObject {
    func reloadTableView()
    func delete(item: ListItem)
}

final class NewProductController: UIViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
 
    @IBOutlet weak var lblQuestionTitle: UILabel!
    @IBOutlet weak var viewFooterActions: UIView!
    @IBOutlet weak var txtViewToBuyDesc: UITextView! {
        didSet {
            self.txtViewToBuyDesc.textColor = UIColor(hexString: "#EBEBEC")
            self.txtViewToBuyDesc.text = "Enter Product"
            let newPosition = self.txtViewToBuyDesc.beginningOfDocument
            self.txtViewToBuyDesc.selectedTextRange = self.txtViewToBuyDesc.textRange(from: newPosition, to: newPosition)
        }
    }
    
    @IBOutlet weak var footerViewBottomConstraint: NSLayoutConstraint!
    
    private var keyboardHeight: CGFloat = 0
    var editableItem: ListItem?
    private var textDidChange = false
    
    weak var delegate: addProductDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addKeyboardObservers()
        self.setUpTextView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.txtViewToBuyDesc.becomeFirstResponder()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.footerViewBottomConstraint.constant += self.viewFooterActions.frame.size.height
        self.view.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated:
                                                        true)
    }
    @IBAction func btnDeleteClicked(_ sender: Any) {
        if editableItem != nil {
            self.delegate.delete(item: self.editableItem!)
        }
        self.navigationController?.popViewController(animated:
                                                        true)
    }
    @IBAction func btnSaveClicked(_ sender: Any) {
        if self.editableItem == nil {
            let toBuyItem = ListItem(context: self.context)
            toBuyItem.id = UUID().uuidString
            toBuyItem.desc = self.txtViewToBuyDesc.text
        } else {
            self.editableItem?.desc = self.txtViewToBuyDesc.text
        }
        (UIApplication.shared.delegate as!
         AppDelegate).saveContext()
        self.delegate.reloadTableView()
        self.navigationController?.popViewController(animated:
                                                        true)
    }
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setUpTextView() {
        if self.editableItem != nil {
            self.lblQuestionTitle.text = "Edit Product"
            self.txtViewToBuyDesc.textColor = UIColor(hexString: "#1E212B")
            self.textDidChange = true
        }
        self.txtViewToBuyDesc.delegate = self
        if self.editableItem != nil {
            self.txtViewToBuyDesc.text = self.editableItem?.desc
        }
    }
    
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: CGRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            if self.keyboardHeight != 0 {return}
            
            self.keyboardHeight = keyboardFrame.size.height
            self.footerViewBottomConstraint.constant += (self.keyboardHeight - 20)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.keyboardHeight == 0 { return }
        self.footerViewBottomConstraint.constant -= self.keyboardHeight
    }
}


extension NewProductController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if !self.textDidChange {
            self.txtViewToBuyDesc.text = ""
            self.txtViewToBuyDesc.textColor = UIColor(hexString: "#1E212B")
            self.textDidChange = true
        }
        return true
        
    }
}
