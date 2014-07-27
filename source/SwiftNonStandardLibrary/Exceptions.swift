//  Swift Non-Standard Library
//
//  Created by Russ Bishop
//  http://github.com/xenadu/SwiftNonStandardLibrary
//
//  MIT licensed; see LICENSE for more information


import Foundation

///Executes a closure that returns no result.
///If an exception is thrown, the catch closure is executed.
///In all cases, the finally closure is executed.
///
///Either the catch or finally closure is required; it is an error to omit both.
///
///The only parameter is a closure to allow for trailing closure syntax, making the try
///statement more like a syntactical "try" statement.
///
/// try {({
///  //do work
/// }, catch: { ex in
///  //on failure
/// }, finally: {
///  //cleanup
/// })}
public func try(maker: ()->(()->(), catch:((NSException!)->())?, finally:(()->())? )) {
    let (action, catch, finally) = maker()
    OSSExceptionHelper.tryInvokeBlock(action, catch, finally)
}

///Executes a closure that returns T
///If an exception is thrown, the catch closure is executed and the overall result will be nil
///In all cases, the finally closure is executed.
///
///Either the catch or finally closure is required; it is an error to omit both.
///
///The only parameter is a closure to allow for trailing closure syntax, making the try
///statement more like a syntactical "try" statement.
///
/// try {({
///  //do work
/// }, catch: { ex in
///  //on failure
/// }, finally: {
///  //cleanup
/// })}
public func try<T: AnyObject>(maker: ()->( ()->T, catch:((NSException!)->())?, finally: (()->())? )) -> T? {
    let (action, catch, finally) = maker()
    let result : AnyObject! = OSSExceptionHelper.tryInvokeBlockWithReturn(action, catch: { ex in
        if let catchClause = catch {
            catchClause(ex)
        }
        return nil
        }, finally: finally)
    if result {
        return result as? T
    } else {
        return nil
    }
}

///Executes a closure that returns T
///If an exception is thrown, the catch closure is executed; if the catch closure returns nil then the overall result is nil,
/// otherwise the catch closure can return an alternate T result
///In all cases, the finally closure is executed.
///
///Either the catch or finally closure is required; it is an error to omit both.
///
///The only parameter is a closure to allow for trailing closure syntax, making the try
///statement more like a syntactical "try" statement.
///
/// try {({
///  //do work
/// }, catch: { ex in
///  //on failure
/// }, finally: {
///  //cleanup
/// })}
public func try<T: AnyObject>(maker: ()->( ()->T, catch:((NSException!)->T)?, finally: (()->())? )) -> T? {
    let (action, catch, finally) = maker()
    let result : AnyObject! = OSSExceptionHelper.tryInvokeBlockWithReturn(action, catch: catch, finally: finally)
    if result {
        return result as? T
    } else {
        return nil
    }
}

///Throws an NSException. This must be in the context of try() or your program will abort since Swift does not handle exceptions natively
public func throw(name:String, message:String) {
    OSSExceptionHelper.throwExceptionNamed(name, message: message)
}

///Throws an NSException. This must be in the context of try() or your program will abort since Swift does not handle exceptions natively
public func throw(ex:NSException) {
    OSSExceptionHelper.throwException(ex)
}