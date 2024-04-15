//
//  signUpView.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/25/23.
//

import SwiftUI
import FirebaseAuth

struct signUpView: View {
    @EnvironmentObject var manager : MapManager
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLogin = false
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Picker("", selection: $isLogin) {
                    Text("Log In")
                        .tag(true)
                    Text("Create Account")
                        .tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Group {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .textFieldStyle(.roundedBorder)
                        .frame(height: 50)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .frame(height: 50)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    if isLogin {
                        manager.loginUser(email: email, password: password)
                    } else {
                        manager.createUser(email: email, password: password)
                    }
                }, label: {
                    Text(isLogin ? "Log In" : "Create Account")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 45)
                        .background(Color.blue)
                        .cornerRadius(8)
                })
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                Spacer()
            }
            .navigationTitle(isLogin ? "Welcome Back" : "Welcome")
        }

    }
}

struct signUpView_Previews: PreviewProvider {
    static var previews: some View {
        signUpView().environmentObject(MapManager())
    }
}
