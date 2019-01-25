//
//  JsApiSwift.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/23.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation

class JsApiSwift: NSObject {
    
    //MUST use "_" to ignore the first argument name explicitly。
    @objc func testSyn( _ arg:String) -> String {
        
        return String(format:"%@[Swift sync call:%@]", arg, "test")
    }
    
    @objc func APPGetNetWork(_ arg:String) ->String {
        return GoodManager.APPGetNetWork()
    }
    
    @objc func APPWinOpen (_ url:String, mark:String, progressBarColor:String, statusBarColor:String){
        GoodManager.APPWinOpen(url:url,mark:mark,progressBarColor:progressBarColor,statusBarColor:statusBarColor)
    }
    
    @objc func APPWinClose(_ mark:String){
        GoodManager.APPWinClose(mark: mark)
    }
    
    @objc func APPExecWinJS(_ mark:String, JSFun:String){
        GoodManager.APPExecWinJS(mark: mark, JSFun: JSFun)
    }
    
    @objc func APPSetValue(key:String,value:String){
        GoodManager.APPSetValue(key: key, value: value)
    }
    
    @objc func APPGetValue(_ key:String) -> String{
        return GoodManager.APPGetValue(key: key)
    }
    
    @objc func APPDelValue(_ key:String){
        GoodManager.APPDelValue(key: key)
    }
    
    @objc func APPOutBrowserOpenURL(_ url:String){
        GoodManager.APPOutBrowserOpenURL(url: url)
    }
    
    @objc func APPGetBankImage(_ callBackfunName:String){
        GoodManager.APPGetBankImage(callBackfunName: callBackfunName)
    }
    
    @objc func APPGetIdentityCardImage(_ callBackfunName:String){
        GoodManager.APPGetIdentityCardImage(callBackfunName: callBackfunName)
    }
    
    @objc func APPChooseSingleImage(_ source:Int, ifNeedEdit:Int, ifOriginalPic:Int, callBackfunName:String){
        GoodManager.APPChooseSingleImage(source: source, ifNeedEdit: ifNeedEdit, ifOriginalPic: ifNeedEdit, callBackfunName: callBackfunName)
    }
    
    @objc func APPChooseMoreImage(_ source:Int, maxNum:Int, ifOriginalPic:Int, callBackfunName:String){
        GoodManager.APPChooseMoreImage(source: source, maxNum: maxNum, ifOriginalPic: ifOriginalPic, callBackfunName: callBackfunName)
    }
    
    @objc func APPPreviewImage(_ paths:String, defaultIndex:Int){
        GoodManager.APPPreviewImage(paths: paths, defaultIndex: defaultIndex)
    }
    
    @objc func APPChooseSingleVideo(_ source: Int, maxVideoLength: Int,callBackfunName: String){
        GoodManager.APPChooseSingleVideo(source: source, maxVideoLength: maxVideoLength, callBackfunName: callBackfunName)
    }
    
    @objc func APPPlayVideo(_ path:String, startPosition:Double, callBackfunName:String){
        GoodManager.APPPlayVideo(path: path, startPosition: startPosition, callBackfunName: callBackfunName)
    }
    
    @objc func APPGetFileSize(_ path:String) ->Int {
        return GoodManager.APPGetFileSize(path: path)
    }
    
    @objc func APPGetFileBase(_ path:String) ->String {
        return GoodManager.APPGetFileBase(path: path)
    }
    
    @objc func APPUploadFile(_ path: String, domainName:String, callBackfunName:String){
        GoodManager.APPUploadFile(path: path, callBackfunName: callBackfunName)
    }
    
    @objc func APPDownFile(_ path: String, domainName:String, callBackfunName:String){
        GoodManager.APPDownFile(path: path, callBackfunName: callBackfunName)
    }
    
    @objc func APPIfExistFile(_ path:String) -> Int {
        return GoodManager.APPIfExistFile(path: path)
    }
    
    @objc func APPDelFile(_ path:String, callBackfunName:String){
        GoodManager.APPDelFile(path: path, callBackfunName: callBackfunName)
    }
    
    @objc func APPPreviewFile(_ path:String){
        GoodManager.APPPreviewFile(path: path)
    }
    
    @objc func APPStartLocation(_ callBackfunName:String){
        GoodManager.APPStartLocation(callBackfunName: callBackfunName)
    }
    
    @objc func APPGetTelBookList(_ callBackfunName:String){
        GoodManager.APPGetTelBookList(callBackfunName: callBackfunName)
    }
    
    @objc func APPChooseTelBook(_ maxNum:Int, callBackfunName:String){
        GoodManager.APPChooseTelBook(maxNum: maxNum, callBackfunName: callBackfunName)
    }
    
    @objc func APPScanQRCode(_ callBackfunName:String){
        GoodManager.APPScanQRCode(callBackfunName: callBackfunName)
    }
    
    @objc func APPSetStatusBarColor(_ color:String){
        GoodManager.AppSetStatusBarColor(color: color)
    }
    
    @objc func APPSetProgressBarColor(_ color:String){
        GoodManager.APPSetProgressBarColor(color: color)
    }
    
    @objc func APPSetBrowserHomeURL(_ url:String){
        GoodManager.APPSetBrowserHomeURL(url: url)
    }
    
}
