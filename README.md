# iOS_CommonCode_Helper

Implemantion Guide :

1. ForceUpdate :

   //Inialise
   
   ForceUpdate_Manager.shared.configure(withAppID: Int)
   
   //Alert 
   
   ForceUpdate_Manager.shared.configureForceUpdateAlert(title: String, message: String, actionBtn: String, cancelBtn: String)
   
   //Check isNeed ForceUpdate or Not
   
   ForceUpdate_Manager.shared.isAppNeedForceUpdate

