//
//  MemeStatus.swift
//  EyeMap
//
//  Created by mario on 2016/07/05.
//  Copyright © 2016年 mario. All rights reserved.
//

import UIKit

public class StatusCheck{
    
    public func checkMEMEStatus(status:MEMEStatus) {
        
        if status == MEME_ERROR_APP_AUTH {
            UIAlertView(title: "App Auth Failed", message: "Invalid Application ID or Client Secret ", delegate: nil, cancelButtonTitle: "OK").show()
        }
        else if status == MEME_ERROR {
            UIAlertView(title: "MEME ERROR", message: "JINS MEMEへのコマンド発行に失敗した", delegate: nil, cancelButtonTitle: "OK").show()
        }
        else if status == MEME_ERROR_SDK_AUTH{
            UIAlertView(title: "SDK Auth Failed", message: "SDK認証に失敗しました。SDKをアップデートしてください", delegate: nil, cancelButtonTitle: "OK").show()
        }
        else if status == MEME_CMD_INVALID {
            UIAlertView(title: "CMD INVALID", message: "コマンド実行を許容していません", delegate: nil, cancelButtonTitle: "OK").show()
        }
        else if status == MEME_ERROR_BL_OFF {
            UIAlertView(title: "Blt Error", message: "Bluetoothが有効でありません", delegate: nil, cancelButtonTitle: "OK").show()
        }
        else if status == MEME_DEVICE_INVALID{
            UIAlertView(title: "Device Invalid", message: "デバイス無効", delegate: nil, cancelButtonTitle: "OK").show()
        }
        else if status == MEME_ERROR_FW_CHECK {
            UIAlertView(title: "FW Check", message: "MEMEのファームウェアが古いです", delegate: nil, cancelButtonTitle: "OK").show()
        }
        else if status == MEME_ERROR_CONNECTION {
            UIAlertView(title: "Connection Faild", message: "JINS MEMEへの接続が確立されていない", delegate: nil, cancelButtonTitle: "OK").show()
        }
        else if status == MEME_OK {
            print("Status: MEME_OK")
        }
    }
}