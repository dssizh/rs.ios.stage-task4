import Foundation

final class CallStation {
    var usersArray:[User]=[]
    var callsArray:[Call]=[]
    var curretnCalls = Dictionary<UUID, Call>();
}

extension CallStation: Station {
    func users() -> [User] {
        return self.usersArray
    }
    
    func add(user: User) {
        if (self.usersArray.firstIndex(of: user) == nil) {
            self.usersArray.append(user);
        }
    }
    
    func remove(user: User) {
        
        if let i = self.usersArray.firstIndex(of: user) {
            self.usersArray.remove(at: i)
        }
    }
    
    func execute(action: CallAction) -> CallID? {
        switch action {
        case .start(from: let user1, to: let user2):
            var isOk:Bool = true;
            if self.usersArray.firstIndex(of: user1) == nil {
                return nil;
            }
            
            var newCall:Call = Call(id:UUID(), incomingUser:user1, outgoingUser:user2, status:CallStatus.calling);
            if self.usersArray.firstIndex(of: user2) == nil {
                newCall.status = CallStatus.ended(reason: CallEndReason.error)
                isOk = false
            }
            
            let user2Calls = self.calls(user: user2)
            for user2Call in user2Calls {
                if user2Call.incomingUser != user1 {
                    isOk = false
                    newCall.status = CallStatus.ended(reason: CallEndReason.userBusy)
                }
            }
            
            
            self.callsArray.append(newCall)
//            self.currentCall = newCall
            if (isOk) {
                self.curretnCalls.updateValue(newCall, forKey: user1.id)
                self.curretnCalls.updateValue(newCall, forKey: user2.id)
            }
            
            return newCall.id
        case .answer(from: let user):
            
            for (index, call) in self.callsArray.enumerated() {
                if call.outgoingUser == user {
                    if self.usersArray.firstIndex(of: user) != nil {
                    self.callsArray[index].status = CallStatus.talk;
                        return call.id;
                    } else {
                        self.callsArray[index].status = CallStatus.ended(reason: CallEndReason.error);
                        self.curretnCalls.removeValue(forKey: call.incomingUser.id)
                        self.curretnCalls.removeValue(forKey: call.outgoingUser.id)
                        return nil;
                    }
                }
            }
        
            return nil
        case .end(from: let user):
            for (index, call) in self.callsArray.enumerated() {
                if call.incomingUser == user {
                    self.callsArray[index].status = CallStatus.ended(reason: CallEndReason.end);
                    self.curretnCalls.removeValue(forKey: call.incomingUser.id)
                    self.curretnCalls.removeValue(forKey: call.outgoingUser.id)
                    return call.id;
                }
                
                if call.outgoingUser == user {
                    if self.callsArray[index].status == CallStatus.talk {
                        self.callsArray[index].status = CallStatus.ended(reason: CallEndReason.end);
                    } else {
                        self.callsArray[index].status = CallStatus.ended(reason: CallEndReason.cancel);
                    }
                    self.curretnCalls.removeValue(forKey: call.incomingUser.id)
                    self.curretnCalls.removeValue(forKey: call.outgoingUser.id)
                    return call.id;
                }
            }
            return nil
        default:
            return nil
        }
    }
    
    func calls() -> [Call] {
        return self.callsArray
    }
    
    func calls(user: User) -> [Call] {
        var result: [Call] = Array<Call>()
        for call in self.callsArray {
        if call.incomingUser == user || call.outgoingUser == user {
            result.append(call)
        }
        }
        
        return result
    }
    
    func call(id: CallID) -> Call? {
        for call in self.callsArray {
            if call.id == id {
                return call
            }
        }
        return nil
    }
    
    func currentCall(user: User) -> Call? {
        return self.curretnCalls[user.id]
    }
}
