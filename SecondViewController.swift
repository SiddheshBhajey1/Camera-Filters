//
//  SecondViewController.swift
//  Camera
//
//  Created by siddhesh.bhajey on 28/02/24.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var applyFilter1Button: UIButton!
    @IBOutlet weak var applyFilter2Button: UIButton!
    @IBOutlet weak var addTextButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var buttonStackView: UIStackView!
    var originalImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageView.image = originalImage
        buttonConfiguration()
        addSaveButton()
        configureTextField()
        textField?.delegate = self
        self.navigationController!.navigationBar.topItem!.title = "Back"
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }

    //MARK: - Apply filters to Image
    private func applyFilterTo(image: UIImage, filterEffect: Filter) -> UIImage? {
        guard let cgImage = image.cgImage,
              let openGLContext = EAGLContext(api: .openGLES2) else {
            return nil
        }
        let context = CIContext(eaglContext: openGLContext)
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: filterEffect.filterName)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        if let filterEffectValue = filterEffect.filterEffectValue,
           let filterEffectValueName = filterEffect.filterEffectValueName {
            filter?.setValue(filterEffectValue, forKey: filterEffectValueName)
        }
        var filteredImage: UIImage?
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage,
           let cgiImageResult = context.createCGImage(output, from: output.extent) {
            filteredImage = UIImage(cgImage: cgiImageResult, scale: originalImage!.scale, orientation: .right)
        }
        return filteredImage
    }

    //MARK: - Adding Save button
    private func addSaveButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveImage))
    }

    //MARK: - Saving Image here
    @objc func saveImage() {
        if imageView.layer.sublayers?.count ?? 0 > 0 {
            UIGraphicsBeginImageContext(imageView.bounds.size)
            
            imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            imageView.image = image
        }
        UIImageWriteToSavedPhotosAlbum(imageView.image ?? UIImage(), self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        if let controller = navigationController?.viewController(class: ViewController.self) {
            controller.savedImage = imageView.image
        }
        navigationController?.popViewController(animated: true)
    }

    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }

    //MARK: - Show alert when image saved or error occured
    func showAlertWith(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    //MARK: - Filter 1 action
    @IBAction func filter1Action(_ sender: Any) {
        if !textField.isHidden {
            textField.isHidden = true
        }
        guard let image = originalImage else {
            return
        }
        imageView.image = applyFilterTo(image: image, filterEffect: Filter(filterName: "CIPhotoEffectProcess", filterEffectValue: nil, filterEffectValueName: nil))
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }

    //MARK: - Filter 2 action
    @IBAction func filter2Action(_ sender: Any) {
        if !textField.isHidden {
            textField.isHidden = true
        }
        guard let image = originalImage else {
            return
        }
        imageView.image = applyFilterTo(image: image, filterEffect: Filter(filterName: "CIPhotoEffectNoir", filterEffectValue: nil, filterEffectValueName: nil))
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }

    //MARK: - Reset action
    @IBAction func resetAction(_ sender: Any) {
        imageView.image = originalImage
        textField.isHidden = true
        textField.resignFirstResponder()
        if imageView.layer.sublayers?.count ?? 0 > 0 {
            imageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }

    //MARK: - Add text action
    @IBAction func addText(_ sender: Any) {
        textField.text = ""
        textField.isHidden = false
    }

    //MARK: - Display text on Image
    private func addTextOnImage(text: String) {
        if imageView.layer.sublayers?.count ?? 0 > 0 {
            imageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        }
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: 20, y: imageView.bounds.height/2, width: imageView.frame.size.width-37, height: imageView.frame.size.height/2)
        // 2
        let string = text
        textLayer.string = string
        // 3
        let fontName: CFString = "Noteworthy-Light" as CFString
        textLayer.font = CTFontCreateWithName(fontName as CFString, 10, nil)
        // 4
        textLayer.foregroundColor = UIColor.yellow.cgColor
        textLayer.isWrapped = true
        textLayer.alignmentMode = CATextLayerAlignmentMode.left
        textLayer.contentsScale = 1.0
        imageView.layer.addSublayer(textLayer)
    }

    //MARK: - Configure buttons
    private func buttonConfiguration() {
        applyFilter1Button.backgroundColor = .clear
        applyFilter1Button.layer.cornerRadius = 10
        applyFilter1Button.tintColor = .white
        applyFilter2Button.backgroundColor = .clear
        applyFilter2Button.layer.cornerRadius = 10
        applyFilter2Button.tintColor = .white
        resetButton.backgroundColor = .clear
        resetButton.layer.cornerRadius = 10
        resetButton.tintColor = .white
        addTextButton.backgroundColor = .clear
        addTextButton.layer.cornerRadius = 10
        addTextButton.tintColor = .white
        buttonStackView.layer.cornerRadius = 10
        buttonStackView.layer.shadowOpacity = 1
        buttonStackView.layer.shadowRadius = 2
        buttonStackView.layer.shadowOffset = CGSize(width: 1, height: 1)
        buttonStackView.layer.shadowColor = UIColor.opaqueSeparator.cgColor

    }

    //MARK: - Configure Text field
    private func configureTextField() {
        textField?.placeholder = "Add text"
        textField?.leftViewMode = .always
        textField?.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField?.autocapitalizationType = .none
        textField?.autocorrectionType = .no
        textField?.layer.masksToBounds = true
        textField?.layer.cornerRadius = 5
        textField?.backgroundColor = .secondarySystemBackground
        textField?.layer.borderWidth = 1.0
        textField?.layer.borderColor = UIColor.secondaryLabel.cgColor
        textField.isHidden = true
    }
}

//MARK: - Text field delegate functions
extension SecondViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
        print("TextField should begin editing method called")
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        print("TextField did begin editing method called")
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        print("TextField should snd editing method called")
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        print("TextField did end editing with reason method called")
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        print("While entering the characters this method gets called")
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        print("TextField should return method called")
        textField.resignFirstResponder()
        addTextOnImage(text: textField.text ?? "")
        textField.isHidden = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        return true
    }

}
