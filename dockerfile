# escape=`

FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# Download the Build Tools bootstrapper.
ADD https://aka.ms/vs/16/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe

# Install Build Tools excluding workloads and components with known issues.
RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --installPath C:\BuildTools `
    --all `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 `
    --remove Microsoft.VisualStudio.Component.Windows81SDK `
 || IF "%ERRORLEVEL%"=="3010" EXIT 0

RUN powershell Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#RUN choco install -y --no-progress netfx-4.8-devpack
#RUN choco install -y --no-progress visualstudio2019buildtools
#RUN choco install -y --no-progress visualstudio2019buildtools --package-parameters "--allWorkloads --includeRecommended --includeOptional --passive --locale en-US"
#RUN choco install -y --no-progress visualstudio2019-workload-vctools
#RUN choco install -y --no-progress visualstudio2019-workload-netweb
#RUN choco install -y --no-progress visualstudio2019-workload-webbuildtools
#RUN choco install -y --no-progress visualstudio2019-workload-azure
#RUN choco install -y --no-progress visualstudio2019testagent

RUN choco install -y --no-progress nodejs
RUN choco install -y --no-progress jdk8
RUN choco install -y --no-progress dotnetcore-sdk
RUN choco install -y --no-progress webdeploy

RUN npm install -g bower
RUN npm install -g grunt
RUN bower -v

ENV JAVA_HOME="C:\Program Files\Java\jdk1.8.0_231"

ENV Team="TechOps"
ENV DC="NY"
ENV BuildTransPort="True"

COPY start.ps1 .

CMD powershell .\start.ps1


# To build image: 
#     docker build -t tfsbuild:1.48 -t tfsbuild:latest -m 2GB .
# docker run -e AZP_URL=[[azure devops server url]] -e AZP_TOKEN=[[azure devops server pat]] -e AZP_AGENT_NAME=%COMPUTERNAME% tfsbuild