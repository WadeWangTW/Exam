//
//  TopListViewController.swift
//  Exam
//
//  Created by Wade Wang on 2020/11/5.
//

import UIKit
import PKHUD
import SwiftFCXRefresh
import SafariServices

class TopListViewController: UIViewController {

    @IBOutlet weak var topListTableView: UITableView!
    @IBOutlet weak var typePicker: UIPickerView!
    var refreshView: FCXRefreshFooterView?
    
    let viewModel = TopListViewModel()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.checkFavorites()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        biding()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TopListViewController {
    func setupUI() {
        navigationItem.title = "Top List"
        let rightBarButton = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(favoriteListClicked(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        
        topListTableView.register(UINib(nibName: "TopListTableViewCell", bundle: nil), forCellReuseIdentifier: "TopListCellId")
        
        refreshView = topListTableView.addFCXRefreshFooter { [weak self](FCXRefreshBaseView) in
            self?.viewModel.loadMore()
        }
    }
    
    func biding(){
        viewModel.start()
        viewModel.isLoading.addObserver {(loading) in
            if loading {
                HUD.show(.progress)
            }
            else {
                HUD.hide()
            }
        }
        
        viewModel.showError = {[weak self] (error) in
            self?.showError(error)
        }
        
        viewModel.topItems.addObserver {[weak self] (topItems) in
            self?.topListTableView.reloadData()
            self?.refreshView?.endRefresh()
        }
    }
    
    @objc func favoriteListClicked(_ id: UIBarButtonItem) {
        let favoriteList = FavoriteListViewController()
        navigationController?.pushViewController(favoriteList, animated: true)
    }
}

extension TopListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.topItems.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopListCellId", for: indexPath) as! TopListTableViewCell
        cell.setup(self, top: viewModel.topItems.value[indexPath.row])
        return cell
    }
    
}

extension TopListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.topItems.value[indexPath.row]
        if let urlString = item.url, let url = URL(string: urlString) {
            let safariView = SFSafariViewController(url: url)
            present(safariView, animated: true, completion: nil)
        }
    }
}

extension TopListViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if component == 0 {
            return viewModel.types.count
        }

        guard let content = viewModel.types[pickerView.selectedRow(inComponent: 0)].content else {
            return 0
        }
        
        return content.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
}

extension TopListViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return viewModel.types[row].title
        }

        guard let content = viewModel.types[pickerView.selectedRow(inComponent: 0)].content else {
            return nil
        }

        return content[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.reloadComponent(1)
        }
        
        viewModel.pickerView(pickerView, didSelectRow: row, inComponent: component)
    }
}

extension TopListViewController: TopListCellDelegate {
    func cell(_ cell: TopListTableViewCell, didClickedFavorite topItem: TopItem) {
        viewModel.setFavoriteState(malId: topItem.mal_id)
    }
    
}
