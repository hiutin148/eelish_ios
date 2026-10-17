
import SwiftUI

struct SignupScreen: View {
    @StateObject private var vm: SignupViewModel
    @EnvironmentObject private var sessionVm: SessionViewModel

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false

    private var valid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && email.contains("@")
        && !password.isEmpty
    }

    private var isLoading: Bool {
        if case .loading = vm.state {
            return true
        }
        return false
    }

    init(viewModel: @autoclosure @escaping () -> SignupViewModel) {
        _vm = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        Form {
            Section(header: Text("Sign up")) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .disabled(isLoading)

                TextField("Name", text: $name)
                    .textContentType(.name)
                    .disabled(isLoading)

                HStack {
                    Group {
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                    }
                    .textContentType(.newPassword)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .frame(maxWidth: .infinity)
                    .disabled(isLoading)

                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(
                            systemName: isPasswordVisible
                                ? "eye.slash"
                                : "eye"
                        )
                    }
                    .disabled(isLoading)
                }
            }

            Section {
                Button {
                    Task {
                        await vm.signup(
                            email: email.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ),
                            name: name.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ),
                            password: password
                        )
                        if vm.state == .loaded {
                            sessionVm.checkSession()
                        }
                    }
                } label: {
                    HStack {
                        Spacer()

                        if isLoading {
                            ProgressView()
                                .padding(.trailing, 4)

                            Text("Signing up...")
                        } else {
                            Text("Sign up")
                        }

                        Spacer()
                    }
                }
                .disabled(!valid || isLoading)
            }

            if case let .failed(message) = vm.state {
                Section {
                    Text(message)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Create account")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SignupScreen(
            viewModel: AppContainer.live().makeSignupViewModel()
        )
    }
    .environment(\.container, .live())
}
