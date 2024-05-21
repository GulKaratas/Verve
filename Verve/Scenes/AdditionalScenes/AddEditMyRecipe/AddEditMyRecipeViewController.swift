//
//  AddEditMyRecipeViewController.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import UIKit
import CoreData
import UserNotifications

struct NotificationConstants {
    static let notificationIdentifier = "com.example.recipeApp.notification"
}

final class AddEditMyRecipeViewController: UIViewController {
    
    private lazy var recipeImgView: UIView = {
        let recipeImgView = UIView()
        recipeImgView.backgroundColor = .clear
        view.addSubview(recipeImgView)
        return recipeImgView
    }()
    
    private lazy var recipeImg: UIImageView = {
        let recipeImg = UIImageView()
        recipeImg.image = UIImage(named: AssetName.recipe_default.rawValue)
        recipeImg.layer.cornerRadius = CornerRadius.image_cell.rawValue
        recipeImg.contentMode = .scaleAspectFit
        recipeImg.backgroundColor = .clear
        recipeImgView.addSubview(recipeImg)
        return recipeImg
    }()
    
    
    private lazy var uploadImgButton: UIButton = {
        let uploadImgButton = UIButton()
        uploadImgButton.setImage(UIImage(named: "upload-icon"), for: .normal)
        uploadImgButton.layer.cornerRadius = CornerRadius.button.rawValue
        uploadImgButton.backgroundColor = UIColor(hexString: Color.border.rawValue)
        recipeImgView.addSubview(uploadImgButton)
        return uploadImgButton
    }()
    
    private lazy var nameField: UITextView = {
        let nameField = UITextView()
        nameField.delegate = self
        nameField.font = .systemFont(ofSize: 17)
        nameField.textColor = UIColor(hexString: Color.secondary.rawValue)
        nameField.backgroundColor = UIColor(hexString: Color.border.rawValue)
        nameField.autocorrectionType = .no
        nameField.layer.cornerRadius = CornerRadius.textView.rawValue
        view.addSubview(nameField)
        return nameField
    }()
    
    private lazy var ingredientsField: UITextView = {
        let ingredientsField = UITextView()
        ingredientsField.delegate = self
        ingredientsField.font = .systemFont(ofSize: 17)
        ingredientsField.textColor = UIColor(hexString: Color.secondary.rawValue)
        ingredientsField.backgroundColor = UIColor(hexString: Color.border.rawValue)
        ingredientsField.autocorrectionType = .no
        ingredientsField.layer.cornerRadius = CornerRadius.textView.rawValue
        view.addSubview(ingredientsField)
        return ingredientsField
    }()
    
    private lazy var methodField: UITextView = {
        let methodField = UITextView()
        methodField.delegate = self
        methodField.font = .systemFont(ofSize: 17)
        methodField.textColor = UIColor(hexString: Color.secondary.rawValue)
        methodField.backgroundColor = UIColor(hexString: Color.border.rawValue)
        methodField.autocorrectionType = .no
        methodField.layer.cornerRadius = CornerRadius.textView.rawValue
        view.addSubview(methodField)
        return methodField
    }()
    
    private(set) lazy var delRecipe: UIButton = {
        let delRecipe = UIButton()
        delRecipe.setTitle("Delete Recipe", for: .normal)
        delRecipe.setTitleColor(UIColor.systemRed, for: .normal)
        delRecipe.backgroundColor = .clear
        view.addSubview(delRecipe)
        return delRecipe
    }()
    
    
    var selectedRecipe: MyRecipe? = nil
    
    private func requestNotificationAuthorization() {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                if let error = error {
                    print("Bildirim izni alınamadı: \(error)")
                } else if granted {
                    print("Bildirim izni alındı!")
                } else {
                    print("Bildirim izni reddedildi.")
                }
            }
        }
        
        // Bildirimi göndermek için bir fonksiyon
        private func sendNotification() {
            let content = UNMutableNotificationContent()
            content.title = "Yeni Tarif Eklendi!"
            content.body = "Yeni bir tarif oluşturuldu veya mevcut bir tarif güncellendi."
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // Örneğin 5 saniye sonra bildirim gönder
            
            let request = UNNotificationRequest(identifier: NotificationConstants.notificationIdentifier, content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request) { error in
                if let error = error {
                    print("Bildirim gönderilirken bir hata oluştu: \(error)")
                } else {
                    print("Bildirim başarıyla gönderildi.")
                }
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        addUploadTap()
        coreDataFunc()
        requestNotificationAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        defineTextFieldsTexts()
        deleteButtonDidAppear()
    }
    
   
    
    private func setUp(){
        setUpView()
        addRecipeImgView()
        addRecipeImg()
        addNameField()
        addIngredientsField()
        addMethodField()
        addUploadImgButton()
    }
    
    private func setUpView() {
        self.view.backgroundColor = UIColor(hexString: Color.background.rawValue)
    }
    
    
    private func coreDataFunc() {
        saveRecipe()
        deleteRecipe()
    }
    
    
    
   
    
    private func addRecipeImgView() {
        recipeImgView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: recipeImgView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 20)
        let left = NSLayoutConstraint(item: recipeImgView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 20)
        let right = NSLayoutConstraint(item: recipeImgView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -20)
        let height = NSLayoutConstraint(item: recipeImgView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 180)
        
        NSLayoutConstraint.activate([top, left, right, height])
    }
    
    private func addRecipeImg() {
        recipeImg.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: recipeImg, attribute: .top, relatedBy: .equal, toItem: recipeImgView, attribute: .top, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: recipeImg, attribute: .left, relatedBy: .equal, toItem: recipeImgView, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: recipeImg, attribute: .right, relatedBy: .equal, toItem: recipeImgView, attribute: .right, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: recipeImg, attribute: .bottom, relatedBy: .equal, toItem: recipeImgView, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([top, left, right, bottom])
    }
    
    private func addUploadImgButton() {
        uploadImgButton.translatesAutoresizingMaskIntoConstraints = false
        
        let right = NSLayoutConstraint(item: uploadImgButton, attribute: .right, relatedBy: .equal, toItem: recipeImgView, attribute: .right, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: uploadImgButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        let width = NSLayoutConstraint(item: uploadImgButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        let bottom = NSLayoutConstraint(item: uploadImgButton, attribute: .bottom, relatedBy: .equal, toItem: recipeImgView, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([right, height, width, bottom])
    }
    
    private func addNameField() {
        nameField.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: nameField, attribute: .top, relatedBy: .equal, toItem: recipeImg, attribute: .bottom, multiplier: 1, constant: 30)
        let left = NSLayoutConstraint(item: nameField, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 20)
        let right = NSLayoutConstraint(item: nameField, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -20)
        let height = NSLayoutConstraint(item: nameField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        
        NSLayoutConstraint.activate([top, left, right, height])
    }
    
    private func addIngredientsField() {
        ingredientsField.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: ingredientsField, attribute: .top, relatedBy: .equal, toItem: nameField, attribute: .bottom, multiplier: 1, constant: 20)
        let left = NSLayoutConstraint(item: ingredientsField, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 20)
        let right = NSLayoutConstraint(item: ingredientsField, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -20)
        let height = NSLayoutConstraint(item: ingredientsField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        
        NSLayoutConstraint.activate([top, left, right, height])
    }
    
    private func addMethodField() {
        methodField.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: methodField, attribute: .top, relatedBy: .equal, toItem: ingredientsField, attribute: .bottom, multiplier: 1, constant: 20)
        let left = NSLayoutConstraint(item: methodField, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 20)
        let right = NSLayoutConstraint(item: methodField, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -20)
        let height = NSLayoutConstraint(item: methodField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        
        NSLayoutConstraint.activate([top, left, right, height])
    }
    
    private func addDelRecipe() {
        delRecipe.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: delRecipe, attribute: .top, relatedBy: .equal, toItem: methodField, attribute: .bottom, multiplier: 1, constant: 20)
        let left = NSLayoutConstraint(item: delRecipe, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 100)
        let right = NSLayoutConstraint(item: delRecipe, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -100)
        let height = NSLayoutConstraint(item: delRecipe, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
        
        NSLayoutConstraint.activate([top, left, right, height])
    }
    
    private func presentImagePicker() {
        let alertController = UIAlertController(title: "Resim Seç", message: nil, preferredStyle: .actionSheet)
                   
        let cameraAction = UIAlertAction(title: "Fotoğraf Çek", style: .default) { _ in
            // Kamera ile fotoğraf çekmeyi uygulayın
        }
                   
        let photoLibraryAction = UIAlertAction(title: "Galeriden Seç", style: .default) { _ in
            self.openPhotoLibrary()
        }
                   
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel)
                   
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
                   
        self.present(alertController, animated: true)
    }

    private func openPhotoLibrary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }

    
    private func addUploadTap() {
        uploadImgButton.addTarget(self, action: #selector(uploadTapped), for: .touchUpInside)
    }
    
    @objc private func uploadTapped() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
   
    private func defineTextFieldsTexts() {
        
        if selectedRecipe != nil {
            nameField.text = selectedRecipe?.name
            nameField.textColor = UIColor(hexString: Color.main.rawValue)
            ingredientsField.text = selectedRecipe?.ingredients
            ingredientsField.textColor = UIColor(hexString: Color.main.rawValue)
            methodField.text = selectedRecipe?.method
            methodField.textColor = UIColor(hexString: Color.main.rawValue)
            recipeImg.image = selectedRecipe?.img
        } else {
            nameField.text = RecipePlaceholder.Title.rawValue
            ingredientsField.text = RecipePlaceholder.Ingredients.rawValue
            methodField.text = RecipePlaceholder.Method.rawValue
        }
    }
    
    private func deleteButtonDidAppear() {
        if selectedRecipe != nil {
            addDelRecipe()
        }
    }
    
    
    
    
    private func saveRecipe() {
        navigationItem.rightBarButtonItem = UIBarButtonItem( barButtonSystemItem: .save, target: self,action: #selector(saveTapped))
    }
    
    
    
    @objc private func saveTapped() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        sendNotification()
        
        if selectedRecipe == nil {
            
            
            let entity = NSEntityDescription.entity(forEntityName: "MyRecipe", in: context)
            let newRecipe = MyRecipe(entity: entity!, insertInto: context)
            
            saveNewComponents(for: newRecipe)
            
            do {
                try context.save()
                myRecipes.append(newRecipe)
                
                
                self.navigationController?.popViewController(animated: true)
                
            } catch {
                print("Context save error: \(error)")
            }
        } else {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyRecipe")
            
            do {
                let results: NSArray = try context.fetch(request) as NSArray
                try results.forEach { result in
                    let recipe = result as! MyRecipe
                    if recipe == selectedRecipe {
                        saveNewComponents(for: recipe)
                        try context.save()
                        
                       
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
            } catch {
                print("Fetch Failed: \(error)")
            }
        }
    }
    
   
    
    private func deleteRecipe() {
        
        delRecipe.addTarget(self, action: #selector(deleteRecipeTapped), for: .touchUpInside)
        
    }
    
    @objc private func deleteRecipeTapped() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyRecipe")
        
        do {
            let results: NSArray = try context.fetch(request) as NSArray
            try results.forEach { result in
                let recipe = result as! MyRecipe
                if recipe == selectedRecipe {
                    
                    recipe.deletedData = Date()
                    
                    try context.save()
                    
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        } catch {
            print("Fetch Failed: \(error)")
        }
    }
    
    
    
    private func saveNewComponents(for recipe: MyRecipe) {
        recipe.name = nameField.text
        recipe.ingredients = ingredientsField.text
        recipe.method = methodField.text
        recipe.img = recipeImg.image
    }
    
}


extension AddEditMyRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            recipeImg.image = image
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


extension AddEditMyRecipeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(hexString: Color.secondary.rawValue) {
            if selectedRecipe == nil {
                textView.text = nil
            }
            textView.textColor = UIColor(hexString: Color.main.rawValue)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty && textView == nameField {
            textView.text = RecipePlaceholder.Title.rawValue
            textView.textColor = UIColor(hexString: Color.secondary.rawValue)
        } else if textView.text.isEmpty && textView == ingredientsField {
            textView.text = RecipePlaceholder.Ingredients.rawValue
            textView.textColor = UIColor(hexString: Color.secondary.rawValue)
        } else if textView.text.isEmpty && textView == methodField {
            textView.text = RecipePlaceholder.Method.rawValue
            textView.textColor = UIColor(hexString: Color.secondary.rawValue)
        }
    }
}

