# run it inside the web terminal
code-server --install-extension ms-python.python
code-server --install-extension ms-toolsai.jupyter
curl -o cpptools.vsix -fsSL "https://github.com/microsoft/vscode-cpptools/releases/download/v1.14.4/cpptools-linux-aarch64.vsix" \
	&& /usr/bin/code-server --install-extension cpptools.vsix \
	&& rm cpptools.vsix
