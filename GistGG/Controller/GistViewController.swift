//
//  GistViewController.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 01/04/21.
//

import UIKit
import SDWebImage

class GistViewController: UIViewController {
    
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var commitsLabel: UILabel!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var filesTableView: UITableView!
    @IBOutlet weak var filesButton: UIButton!
    
    var gistUrl: String?
    private var gistManager = GistManager()
    private var comments = [(String, String, String, Date)]()
    private var files = [(String, String, String)]()
    private let spinnerView = SpinnerViewController()
    private var showFiles = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filesTableView.delegate = self
        filesTableView.dataSource = self
        gistManager.delegate = self
        
        filesTableView.register(UINib(nibName: K.Cell.Nib.commentCellNibName, bundle: nil), forCellReuseIdentifier: K.Cell.commentCell)
        
        filesTableView.register(UINib(nibName: K.Cell.Nib.fileCellNibName, bundle: nil), forCellReuseIdentifier: K.Cell.fileCell)
        
        loadGist(url: gistUrl!)
        
        ownerImageView.layer.cornerRadius = ownerImageView.frame.size.width/2
        ownerImageView.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
        }
        navBar.tintColor = UIColor.white
    }
    
    private func loadGist(url: String) {
        addChild(spinnerView)
        spinnerView.view.frame = view.frame
        view.addSubview(spinnerView.view)
        spinnerView.didMove(toParent: self)
        
        let id = String(url.split(separator: "/").last!)
        gistManager.fetchRequest(with: id)
        filesTableView.reloadData()
    }
    @IBAction func commentsButtonTapped(_ sender: UIButton) {
        showFiles = false
        
        filesTableView.reloadData()
        
        var indexPathToReload = [IndexPath]()
        for index in comments.indices {
            let indexPath = IndexPath(row: index, section: 0)
            indexPathToReload.append(indexPath)
        }
        filesTableView.reloadRows(at: indexPathToReload, with: .right)
    }
    @IBAction func filesButtonTapped(_ sender: UIButton) {
        showFiles = true
        
        filesTableView.reloadData()
        
        var indexPathToReload = [IndexPath]()
        for index in files.indices {
            let indexPath = IndexPath(row: index, section: 0)
            indexPathToReload.append(indexPath)
        }
        filesTableView.reloadRows(at: indexPathToReload, with: .left)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == K.Segue.gistToviewCodeSegue){
            let destinationVC = segue.destination as! CodeViewController
            
            if let indexPath = filesTableView.indexPathForSelectedRow {
                destinationVC.file = files[indexPath.row]
            }
        }
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
        files = gistManager.getFilesDictionary()
        
        DispatchQueue.main.async {
            
            if let ownerName = gistManager.getGistOwnerName(){
                self.navigationItem.title = ownerName
            }
            
            let textBubleImage = NSTextAttachment()
            textBubleImage.image = UIImage(systemName: "arrow.right.doc.on.clipboard")?.withTintColor(.white)
            
            let filesString = NSMutableAttributedString()
            filesString.append(NSAttributedString(string: "\(numberOfFiles) "))
            filesString.append(NSAttributedString(attachment: textBubleImage))
            self.filesButton.setAttributedTitle(filesString, for: .normal)
            
            self.filesButton.layer.borderWidth = 1
            self.filesButton.layer.borderColor = UIColor.white.cgColor
            self.filesButton.layer.cornerRadius = 15
            self.filesButton.layer.masksToBounds = true
            
            
            let commentImage = NSTextAttachment()
            commentImage.image = UIImage(systemName: "text.bubble.fill")?.withTintColor(.white)
            
            let comentsString = NSMutableAttributedString()
            comentsString.append(NSAttributedString(string: "\(numberOfComments) "))
            comentsString.append(NSAttributedString(attachment: commentImage))
            self.commentsButton.setAttributedTitle(comentsString, for: .normal)
            self.commentsButton.layer.borderWidth = 1
            self.commentsButton.layer.borderColor = UIColor.white.cgColor
            self.commentsButton.layer.cornerRadius = 15
            self.commentsButton.layer.masksToBounds = true
            
            
            let commitImage = NSTextAttachment()
            commitImage.image = UIImage(systemName: "pencil")?.withTintColor(.white)
            
            let commitsString = NSMutableAttributedString()
            commitsString.append(NSAttributedString(string: "\(numberOfCommits) "))
            commitsString.append(NSAttributedString(attachment: commitImage))
            
            self.commitsLabel?.attributedText = commitsString
            
            
            if let ownerImageUrl = gistManager.getGistUrlImage(){
                self.ownerImageView?.sd_setImage(with: URL(string: ownerImageUrl))
            } else {
                self.ownerImageView?.isHidden = true
            }
            
            self.spinnerView.willMove(toParent: nil)
            self.spinnerView.view.removeFromSuperview()
            self.spinnerView.removeFromParent()
            
            self.filesTableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(showFiles){
            performSegue(withIdentifier: K.Segue.gistToviewCodeSegue, sender: nil)
        }
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
