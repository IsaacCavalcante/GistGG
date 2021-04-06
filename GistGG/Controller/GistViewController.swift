//
//  GistViewController.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 01/04/21.
//

import UIKit
import SDWebImage

class GistViewController: UIViewController, UINavigationControllerDelegate, SpinnerDelegate {
    
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var commitsLabel: UILabel!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var filesButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    
    var gistUrl: String?
    var spinnerView = SpinnerViewController()
    private var gistManager = GistManager()
    private var comments = [(String, String, String, Date)]()
    private var files = [(String, String, String)]()
    private var showFiles = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTableView.delegate = self
        contentTableView.dataSource = self
        gistManager.delegate = self
        spinnerView.delegate = self
        
//        contentTableView.rowHeight  = UITableView.automaticDimension
//        contentTableView.estimatedRowHeight = 80
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        contentTableView.register(UINib(nibName: K.Cell.Nib.commentCellNibName, bundle: nil), forCellReuseIdentifier: K.Cell.commentCell)
        contentTableView.register(UINib(nibName: K.Cell.Nib.fileCellNibName, bundle: nil), forCellReuseIdentifier: K.Cell.fileCell)
        
        roundButton(button: commentsButton)
        roundButton(button: filesButton)
        
        let commentButtonAttributedString = self.setUpAttributedString(withIcon: "paperplane.fill")
        self.commentButton.setAttributedTitle(commentButtonAttributedString, for: .normal)
        
        ownerImageView.layer.cornerRadius = ownerImageView.frame.size.width/2
        ownerImageView.clipsToBounds = true
        
        loadGist(url: gistUrl!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
        }
        navBar.tintColor = UIColor.white
    }
    
    @IBAction func commentsButtonTapped(_ sender: UIButton) {
        showFiles = false
        reloadTableViewWithEffect(objects: comments, effect: .right)
    }
    
    @IBAction func filesButtonTapped(_ sender: UIButton) {
        showFiles = true
        reloadTableViewWithEffect(objects: files, effect: .left)
    }
    
    @IBAction func commentButtonTapped(_ sender: UIButton) {
        if let comment = commentTextField.text {
            gistManager.createComment(comment: comment)
            commentTextField.text = ""
            commentTextField.resignFirstResponder()
        } else {
            showAlertError(errorMessage: "Write some texto to create a comment")
        }
    }
    
    private func showAlertError (errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func reloadTableViewWithEffect<T>(objects: [T], effect: UITableView.RowAnimation) {
        contentTableView.reloadData()
        
        var indexPathToReload = [IndexPath]()
        for index in objects.indices {
            let indexPath = IndexPath(row: index, section: 0)
            indexPathToReload.append(indexPath)
        }
        
        contentTableView.reloadRows(at: indexPathToReload, with: effect)
    }
    
    private func roundButton(button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
    }
    
    private func setUpAttributedString (withIcon icon: String, text: String = "", andColor color: UIColor? = .white) -> NSAttributedString{
        let imageAttributedString = NSTextAttachment()
        imageAttributedString.image = UIImage(systemName: icon)?.withTintColor(color!)
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: text))
        attributedString.append(NSAttributedString(attachment: imageAttributedString))
        
        return attributedString
    }
    
    private func loadGist(url: String) {
        spinnerView.spinnerOn()
        
        let url = gistManager.mountUrl(parameters: String(url.split(separator: "/").last!))
        gistManager.performRequest(url: url)
    }
}

//MARK: - GistManagerDelegate
extension GistViewController: GistManagerDelegate {
    
    func updateGistInformation(_ gistManager: GistManager) {
        self.gistManager = gistManager
        
        let numberOfFiles = gistManager.getNumberOfFiles()
        let numberOfComments = gistManager.getNumberOfComments()
        let numberOfCommits = gistManager.getNumberOfCommits()
        
        comments = gistManager.getComments()
        files = gistManager.getFiles()
        
        DispatchQueue.main.async {
            
            if let ownerName = gistManager.getGistOwnerName(){
                self.navigationItem.title = ownerName
            }
             
            let filesButtonAttributedString = self.setUpAttributedString(withIcon: "arrow.right.doc.on.clipboard", text: "\(numberOfFiles) ")
            self.filesButton.setAttributedTitle(filesButtonAttributedString, for: .normal)
            
            let commentsButtonAttributedString = self.setUpAttributedString(withIcon: "text.bubble.fill", text: "\(numberOfComments) ")
            self.commentsButton.setAttributedTitle(commentsButtonAttributedString, for: .normal)
            
            let commitsLabelAttributedString = self.setUpAttributedString(withIcon: "pencil", text: "\(numberOfCommits) ")
            self.commitsLabel?.attributedText = commitsLabelAttributedString
            
            if let ownerImageUrl = gistManager.getGistUrlImage(){
                self.ownerImageView?.sd_setImage(with: URL(string: ownerImageUrl))
            } else {
                self.ownerImageView?.isHidden = true
            }
            
            self.spinnerView.spinnerOff()
            self.contentTableView.reloadData()
        }
    }
    
    func updateGistComments(_ gistManager: GistManager) {
        self.comments = self.gistManager.getComments()
        DispatchQueue.main.async {
            let numberOfComments = self.gistManager.getNumberOfComments()
            
            let commentsButtonAttributedString = self.setUpAttributedString(withIcon: "text.bubble.fill", text: "\(numberOfComments) ")
            self.commentsButton.setAttributedTitle(commentsButtonAttributedString, for: .normal)
            
            self.contentTableView.insertRows(at: [IndexPath(row: self.comments.count - 1, section: 0)], with: .right)
            self.contentTableView.scrollToRow(at: IndexPath(row: self.comments.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
            self.showAlertError(errorMessage: "Error ao tentar carregar gist")
        }
        
    }
    
    func didFailCreateCommentWithError(error: Error) {
        showAlertError(errorMessage: "Error ao tentar criar comentário. Seu comentário não foi criado.")
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension GistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = showFiles ? files.count : comments.count
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        if(showFiles){
            let fileCell = tableView.dequeueReusableCell(withIdentifier: K.Cell.fileCell, for: indexPath) as! FileTableViewCell
            fileCell.fileNameLabel.text = files[indexPath.row].0
            fileCell.languageNameLabel.text = files[indexPath.row].1
            
            cell = fileCell
        } else {
            let commentCell = tableView.dequeueReusableCell(withIdentifier: K.Cell.commentCell, for: indexPath) as! CommentTableViewCell
            commentCell.ownerNameLabel.text = comments[indexPath.row].0
            if let ownerImageUrl = URL(string: comments[indexPath.row].1){
                commentCell.ownerImage.sd_setImage(with: ownerImageUrl)
            }else{
                commentCell.ownerImage.isHidden = true
            }
            commentCell.commentLabel.text = comments[indexPath.row].2
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YY"
            commentCell.dateLabel.text = dateFormatter.string(from: comments[indexPath.row].3)
            
            cell = commentCell
        }   
        return cell
    }
}
