//
//  AddEpisodeViewController.swift
//  TVShows
//
//  Created by Sandro Domitran on 27/07/2019.
//  Copyright © 2019 Sandro Domitran. All rights reserved.
//

import UIKit
import UnderLineTextField
import SVProgressHUD
import Alamofire
import CodableAlamofire

protocol AddNewEpisodeDelegate: class {
    func didSucceed()
}

class AddEpisodeViewController: UIViewController{
    @IBOutlet weak var uploadPhotoButton: UIButton!
    @IBOutlet weak var episodeInfoStack: UIStackView!
    @IBOutlet weak var uploadedImage: UIImageView!
    
    var loginUser: LoginUser?
    var showId: String?
   
    weak var delegate: AddNewEpisodeDelegate?
    private var episodeTitleField: UITextField!
    private var seasonNumField: UITextField!
    private var episodeNumField: UITextField!
    private var episodeDescriptionField: UITextField!
    let imagePicker = UIImagePickerController()
    private var mediaId: String?
    private var media: Media? {
        didSet {
            mediaId = media?.id
        }
    }
   
    private var episodeTitle: String {
        if let text = episodeTitleField.text {
            return text
        } else{
            return ""
        }
    }
    private var seasonNum: String {
        if let text = seasonNumField.text {
            return text
        } else{
            return ""
        }
    }
    private var episodeNum: String {
        if let text = episodeNumField.text {
            return text
        } else{
            return ""
        }
    }
    private var episodeDescription: String {
        if let text = episodeDescriptionField.text {
            return text
        } else{
            return ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.modalPresentationStyle = .currentContext
        imagePicker.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didSelectCancel)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(didSelectAddShow)
        )
        
        navigationItem.leftBarButtonItem?.tintColor = .pink
        navigationItem.rightBarButtonItem?.tintColor = .pink
        
        uploadPhotoButton.tintColor = .pink
        uploadPhotoButton.layer.cornerRadius = 10
        
        episodeTitleField = UnderLineTextField()
        seasonNumField = UnderLineTextField()
        episodeNumField = UnderLineTextField()
        episodeDescriptionField = UnderLineTextField()
        
        episodeTitleField.placeholder = "Episode title"
        seasonNumField.placeholder = "Season n."
        episodeNumField.placeholder = "Episode n."
        episodeDescriptionField.placeholder = "Episode description"
        
        episodeInfoStack.distribution = .fillEqually
        episodeInfoStack.addArrangedSubview(episodeTitleField)
        episodeInfoStack.addArrangedSubview(seasonNumField)
        episodeInfoStack.addArrangedSubview(episodeNumField)
        episodeInfoStack.addArrangedSubview(episodeDescriptionField)
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func didSelectAddShow() {
        imagePicker.delegate = self
        guard let token = loginUser?.token
            else {
                print("Invalid user")
                return
        }
        
        self.uploadImageOnAPI(token: token) {
            self.addEpisode()
        }
            
        
        
    }
    
    @objc func didSelectCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func uploadPhotoButtonClicked(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }

}

extension AddEpisodeViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.uploadedImage.contentMode = .scaleAspectFit
            self.uploadedImage.image = pickedImage
        }
        imagePicker.dismiss(animated: true)
    }
    
}

private extension AddEpisodeViewController {
    func uploadImageOnAPI(token: String, finished: @escaping ()->Void) {
        let headers = ["Authorization": token]
        guard let someUIImage = uploadedImage.image
            else { return }
        let imageByteData = someUIImage.pngData()!
        SVProgressHUD.show()
        Alamofire
            .upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageByteData,
                                         withName: "file",
                                         fileName: "image.png",
                                         mimeType: "image/png")
            }, to: "https://api.infinum.academy/api/media",
               method: .post,
               headers: headers)
            { [weak self] result in
                switch result {
                case .success(let uploadRequest, _, _):
                    self?.processUploadRequest(uploadRequest, finished: finished)
                case .failure(let encodingError):
                     print(encodingError)
                } }
       
    }
    func processUploadRequest(_ uploadRequest: UploadRequest, finished: @escaping ()->Void) {
        uploadRequest
            .responseDecodableObject(keyPath: "data") { [weak self] (response:DataResponse<Media>) in
                switch response.result {
                case .success(let media):
                    self?.media = media
                    print("Proceed to add episode call...")
                    finished()
                case .failure(let error):
                    print("FAILURE: \(error)")
                }
        }
    }
    
    func addEpisode(){
        guard let token = loginUser?.token
            else {
                print("Invalid user")
                return
            }
        guard let id = showId
            else {
                return
            }   
        let headers = ["Authorization" : token]
        let parameters: [String:String] = [
            "showId": id,
            "mediaId": media?.id ?? "",
            "title": episodeTitle,
            "description": episodeDescription,
            "episodeNumber": episodeNum,
            "season": seasonNum
        ]
        
        Alamofire
            .request("https://api.infinum.academy/api/episodes",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default,
                     headers: headers
            )
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { (response: DataResponse<Episode>) in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success:
                    print("Success")
                    self.delegate?.didSucceed()
                    self.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    self.alertMessage(title: "Failed", message: "API failure")
                    print(error)
                }
        }
    }
    
}

