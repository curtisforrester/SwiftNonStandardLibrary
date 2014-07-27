//
//  Net.swift
//  SwiftNonStandardLibrary
//
//  Created by User on 7/19/14.
//  Copyright (c) 2014 User. All rights reserved.
//

import Foundation



public class Net {
//    
//    //TODO: figure out the shape of this class - what should it be called, what methods should it have
//    //      and implement the appropriate return types and copy the values over so we can return swift-ish objects instead
//    func findHost() {
//        var hints = addrinfo(
//            ai_flags: 0,
//            ai_family: AF_UNSPEC,
//            ai_socktype: SOCK_STREAM,
//            ai_protocol: IPPROTO_TCP,
//            ai_addrlen: 0,
//            ai_canonname: nil,
//            ai_addr: nil,
//            ai_next: nil)
//        
//        let host:CString = "www.google.com"
//        let port:CString = "http"
//        var result = UnsafePointer<addrinfo>.null()
//        
//        let error = getaddrinfo(host, port, &hints, &result)
//        
//        
//        if(error == 0) {
//            for var res = result; res; res = res.memory.ai_next {
//                if res.memory.ai_family == AF_INET {
//                    var ipAddress = StringBuffer(INET_ADDRSTRLEN)
//                    if inet_ntop(res.memory.ai_family,
//                        res.memory.ai_addr, ipAddress, ipAddress.ulength32)
//                    {
//                        println("IPv4 \(ipAddress) for host \(host):\(port)")
//                    }
//                    
//                    if res.memory.ai_family == AF_INET {
//                        let s = UnsafePointer<sockaddr_in>(res.memory.ai_addr).memory
//                        let ip4addr:UInt32 = s.sin_addr.s_addr
//                    }
//                    
//                }
//                else if res.memory.ai_family == AF_INET6 {
//                    var ipAddress = StringBuffer(INET6_ADDRSTRLEN)
//                    if inet_ntop(res.memory.ai_family,
//                        res.memory.ai_addr, ipAddress, UInt32(INET6_ADDRSTRLEN))
//                    {
//                        println("IPv6 \(ipAddress) for host \(host):\(port)")
//                    }
//                    
//                    if res.memory.ai_family == AF_INET6 {
//                        let s = UnsafePointer<sockaddr_in6>(res.memory.ai_addr).memory
//                        let opaqueAddr = s.sin6_addr
//                        let portNum = s.sin6_port
//                    }
//                }
//            }
//            
//            //free the chain
//            freeaddrinfo(result)
//        }
//
//    }
}