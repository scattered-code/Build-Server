# escape=`

FROM microsoft/dotnet-framework:4.7.2-sdk-windowsservercore-1709


RUN powershell Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RUN choco install -y --no-progress visualstudio2017buildtools
RUN choco install -y --no-progress visualstudio2017-workload-vctools
RUN choco install -y --no-progress visualstudio2017-workload-netweb
RUN choco install -y --no-progress visualstudio2017-workload-webbuildtools
RUN choco install -y --no-progress visualstudio2017-workload-azure
#RUN choco install -y --no-progress visualstudio2017testagent

RUN choco install -y --no-progress nodejs
RUN choco install -y --no-progress jdk8
RUN choco install -y --no-progress netfx-4.7.2-devpack
RUN choco install -y --no-progress dotnetcore-sdk
RUN choco install -y --no-progress webdeploy

RUN npm install -g bower
RUN npm install -g grunt
RUN bower -v

ENV JAVA_HOME="C:\Program Files\Java\jdk1.8.0_201"

ADD http://dl.bintray.com/jeremy-long/owasp/dependency-check-5.0.0-M1-release.zip C:\TEMP\dependency-check-5.0.0-M1-release.zip
RUN powershell -Command "expand-archive -Path 'C:\TEMP\dependency-check-5.0.0-M1-release.zip' -DestinationPath 'c:\tools\'"

RUN choco install azure-pipelines-agent -y

WORKDIR C:\agent

ENTRYPOINT C:\\agent\\config.cmd --unattended --url [[TFS_URL]] --auth pat --token [[TFS_AccessToken]] --pool default --agent %COMPUTERNAME% --acceptTeeEula; c:\\agent\\run.cmd; C:\\agent\\config.cmd remove


# To build image: 
#     docker build -t tfsbuild:1.48 -t tfsbuild:latest -m 2GB .
# docker run tfsbuild