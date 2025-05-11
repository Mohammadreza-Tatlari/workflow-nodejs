## express app

Access with browser http://localhost:8080

the purpose of this repository is to test out the [Github actions](https://github.com/features/actions) and Pipeline deployment with [WatchTower](https://containrrr.dev/watchtower/).



### Github to Docker hub pushser.
this repository also has a bash script file that will take 3 arguments: <br>
`<Github_Repository_URL> <Docker_Hub_Repository_Name> [Docker_Tag]` <br>
`<GitHub_Repository_URL>`: The URL of the GitHub repository to download (e.g., https://github.com/user/repo). <br>
`<Docker_Hub_Repository_Name>`: The name of the repository on Docker Hub (e.g., username/my-image). <br>
`[Docker_Tag]`: (Optional) The tag for the Docker image. Defaults to 'latest'. <br>

#### Purpose of this script
it takes a github repository URL that has dockerfile in it, then it will clone it can build its Dockerfile into an image. <br>
after image is created, it will log in to dockerhub and push the newly created image from the git repo into dockerhub repository with defined tag and name.





