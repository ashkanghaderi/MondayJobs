
 import Foundation
 import SkeletonView
 

 extension UIView {
    
    
    // my custom Variables
    enum ViewAssociatedKeys {
        static var isHideOnSkeleton = "isHideOnSkeleton"
    }
    
    // HideOnSkeleton
    @IBInspectable
    var hideOnSkeleton: Bool  {
        get {  self.isHideOnSkeleton}
        set {  isHideOnSkeleton = newValue }
    }
    
    
    // Custom Skeleton funcs
    func customStopSkeleton(){
        self.hideSkeleton()
        if self.hideOnSkeleton {
            self.isHidden = false
        }
        for view in self.subviews{
            view.customStopSkeleton()
        }
    }
    
    func customShowSkeleton(){
        self.showAnimatedGradientSkeleton()
        if self.hideOnSkeleton {
            self.isHidden = true
        }
        for view in self.subviews{
            view.customShowSkeleton()
        }
    }
    
 }
 
 
 
 //MARK: private funcs
 extension UIView {
   
    private var isHideOnSkeleton: Bool! {
          get { return ao_get(pkey: &ViewAssociatedKeys.isHideOnSkeleton) as? Bool ?? false }
          set { ao_set(newValue ?? false, pkey: &ViewAssociatedKeys.isHideOnSkeleton) }
      }
    
    
 }

 
 
 //MARK: Copy of skeletonView
 //file **AssociationPolicy** in pod
 
 extension AssociatedObjects {
    /// wrapper around `objc_getAssociatedObject`
    func ao_get(pkey: UnsafeRawPointer) -> Any? {
        return objc_getAssociatedObject(self, pkey)
    }
    
    /// wrapper around `objc_setAssociatedObject`
    func ao_set(_ value: Any, pkey: UnsafeRawPointer, policy: AssociationPolicy = .retainNonatomic) {
        objc_setAssociatedObject(self, pkey, value, policy.objc)
    }
 }
 
 protocol AssociatedObjects: class { }
 extension NSObject: AssociatedObjects { }

 //Partially copy/pasted from https://github.com/jameslintaylor/AssociatedObjects/blob/master/AssociatedObjects/AssociatedObjects.swift
 enum AssociationPolicy: UInt {
     // raw values map to objc_AssociationPolicy's raw values
     case assign = 0
     case copy = 771
     case copyNonatomic = 3
     case retain = 769
     case retainNonatomic = 1
     
     var objc: objc_AssociationPolicy {
         return objc_AssociationPolicy(rawValue: rawValue)!
     }
 }
