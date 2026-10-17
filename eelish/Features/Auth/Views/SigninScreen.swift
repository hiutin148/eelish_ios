import SwiftUI

struct SigninScreen: View {
    @StateObject private var vm: SigninViewModel
    @EnvironmentObject private var sessionVm: SessionViewModel
    @Environment(\.container) private var container

    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false

    private var trimmedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var valid: Bool {
        trimmedEmail.contains("@") && !password.isEmpty
    }

    private var isLoading: Bool {
        if case .loading = vm.state {
            return true
        }
        return false
    }

    init(viewModel: @autoclosure @escaping () -> SigninViewModel) {
        _vm = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        Form {
            Section(header: Text("Sign in")) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .disabled(isLoading)

                HStack {
                    Group {
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                    }
                    .textContentType(.password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .frame(maxWidth: .infinity)
                    .disabled(isLoading)

                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                    }
                    .buttonStyle(.borderless)
                    .disabled(isLoading)
                }
            }

            Section {
                Button {
                    Task {
                        await vm.signin(
                            email: trimmedEmail,
                            password: password
                        )
                        if case .loaded = vm.state {
                            sessionVm.checkSession()
                        }
                    }
                } label: {
                    HStack {
                        Spacer()

                        if isLoading {
                            ProgressView()
                                .padding(.trailing, 4)

                            Text("Signing in...")
                        } else {
                            Text("Sign in")
                        }

                        Spacer()
                    }
                }
                .disabled(!valid || isLoading)
            }

            Section {
                NavigationLink {
                    SignupScreen(
                        viewModel: container.makeSignupViewModel()
                    )
                } label: {
                    HStack {
                        Text("Don't have an account?")
                            .foregroundStyle(.secondary)
                        Text("Sign up")
                            .foregroundStyle(.tint)
                    }
                }
                .disabled(isLoading)
            }

            if case let .failed(message) = vm.state {
                Section {
                    Text(message)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Sign in")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SigninScreen(
            viewModel: AppContainer.live().makeSigninViewModel()
        )
    }
    .environment(\.container, .live())
}
