//
//  VideoChatNavigator.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/12/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import UIKit

class VideoNavigator {
    
    private let navigationController: UINavigationController
    private let services: Domain.UseCaseProvider
    
    init(services: Domain.UseCaseProvider, navigationController: UINavigationController) {
        self.services = services
        self.navigationController = navigationController
    }
    
    func setup(roomModel: VideoRoomModel) {
        let vidVC = VideoViewController(nibName: "VideoViewController", bundle: nil)
        vidVC.viewModel = VideoViewModel(navigator: self, useCase: services.makeVideoUseCase(),roomModel: roomModel)
        navigationController.pushViewController(vidVC, animated: true)
    }
    
    
    func toErrorPage(error: Error) {
        
    }
    
    func goBack(_ result: String){
        navigationController.popViewController(animated: true)
    }
    
   
    
    
}
