# Build-Server
Azure DevOps Server build host

Replace `[[TFS_URL]]` and `[[TFS_AccessToken]]` with the url and access server of your Azure DevOps Server.
To build a new image, run `docker build -t tfsbuild:1.01 -t tfsbuild:latest -m 2GB .` (make sure to increment the image version on the tfsbuild tag)
Then run `docker run tfsbuild`
