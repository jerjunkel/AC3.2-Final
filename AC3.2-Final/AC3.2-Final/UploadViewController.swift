//
//  UploadViewController.swift
//  AC3.2-Final
//
//  Created by Jermaine Kelly on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import MobileCoreServices
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class UploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate {
    private var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = doneButton
        self.imagePickController.delegate = self
        self.commentTextView.delegate = self
        self.title = "Upload"
        
        setUpViews()
    }
    
    //MARK:- SetUpView
    private func setUpViews(){
        
        self.edgesForExtendedLayout = []
        self.view.addSubview(imageView)
        self.view.addSubview(commentTextView)
        
        imageView.snp.makeConstraints { (view) in
            view.top.trailing.leading.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.7)
        }
        
        imageView.addGestureRecognizer(tapGuesture)
        
        commentTextView.snp.makeConstraints { (view) in
            view.top.equalTo(imageView.snp.bottom).offset(10)
            view.leading.equalToSuperview().offset(10)
            view.trailing.equalToSuperview().inset(10)
            view.height.equalToSuperview().multipliedBy(0.2)
        }
    }
    
    //MARK: - Utilities
    
    internal func upload(){
        
        guard let imageToUpload = selectedImage else {
            self.showAlert(title: "Please select an image"); return }
        
        let comment = commentTextView.text.trimmingCharacters(in: CharacterSet.whitespaces)
        
        guard comment != "" else { self.showAlert(title: "Please add a comment"); return}
        guard let userId = FIRAuth.auth()?.currentUser?.uid else {return}
        
        let databaseRef = FIRDatabase.database().reference().child("posts")
        let childRef = databaseRef.childByAutoId()
        let storageRef = FIRStorage.storage().reference(forURL: "gs://ac-32-final.appspot.com")
        let imageRef = storageRef.child("images/\(childRef.key)")
        let postDic = ["userId": userId,"comment":comment]
        
        childRef.setValue(postDic) { (error, ref) in
            if let error = error{
                print(error.localizedDescription)
            }else{
                print("post added")
            }
        }
        
        guard let imageData = UIImageJPEGRepresentation(imageToUpload, 0.5) else { return }
        
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        
        imageRef.put(imageData, metadata: metaData) { (metaData, error) in
            
            if let error = error{
                self.showAlert(title: "Upload Failed!", message: error.localizedDescription)
            }else{
                self.showAlert(title: "Photo uploaded!")
                self.selectedImage = nil
            }
        }
    }
    
    internal func choosePicture(){
        present(imagePickController, animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String = "", handler: ((UIAlertAction) -> Void)? = nil){
        let alert :UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- ImagePicker Delegate method
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.contentMode = .scaleToFill
            self.selectedImage = image
            self.imageView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    
    //TextView Delegate methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add a comment..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    //MARK: - Views
    private lazy var tapGuesture: UITapGestureRecognizer = {
        let tapGuest = UITapGestureRecognizer()
        tapGuest.addTarget(self, action: #selector(self.choosePicture))
        return tapGuest
    }()
    
    private let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "camera_icon")
        imageView.contentMode = .center
        imageView.backgroundColor = .lightGray
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let commentTextView: UITextView = {
        let textView: UITextView = UITextView()
        textView.text = "Add a comment..."
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = .lightGray
        return textView
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.upload))
        return button
        
    }()
    
    private let imagePickController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [String(kUTTypeImage)]
        return picker
        
    }()
}
