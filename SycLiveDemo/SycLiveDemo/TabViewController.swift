//
//  TabViewController.swift
//  SycDemo
//
//  Created by rigour on 2017/12/19.
//  Copyright © 2017年 syc. All rights reserved.
//

import UIKit

class TabViewController: UIViewController {
    
    private var tabView: UITableView!
    private let cellIdentifices = "cell"
    private lazy var datas: [String] = {
        let arr = ["ijkplayer播放器(m3u8)", "LFLiveKit 推流"]
        return arr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "nav title"
        
        tabView = UITableView(frame: self.view.bounds, style: UITableViewStyle.plain)
        tabView.delegate = self
        tabView.dataSource = self
        
        tabView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifices)
        tabView.tableFooterView = UIView()
        
        tabView.rowHeight = UITableViewAutomaticDimension
        tabView.estimatedRowHeight = 44.0
        
        self.view.addSubview(tabView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TabViewController: UITableViewDataSource{
    // MARK: table data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifices, for: indexPath)
        cell.selectionStyle = .gray
        cell.accessoryType = .disclosureIndicator
        
        let data = self.datas[indexPath.row]
        cell.textLabel?.text = data
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension TabViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var v: UIViewController?
        
        switch indexPath.row {
        case 0:
            v = IJKPlayerViewController()
        case 1:
            v = LFLiveKitDemoViewController()
        default:
            break
        }
        if v != nil{
            self.navigationController?.pushViewController(v!, animated: true)
        }
        
    }
}
