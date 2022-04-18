pipeline {

  agent any
  stages {
    stage('Configure') {
      when { anyOf { branch 'main'; branch 'trial' } }
      steps {
        script {
          GIT_TAG = sh(returnStdout: true, script: "git tag | head -1").trim()
          echo "${GIT_TAG}"
          echo "$GIT_TAG"
          GIT_HASH = sh(returnStdout: true, script: "git rev-parse --short HEAD").trim()
          echo "$GIT_HASH"
       }
      }
    }
    stage('Build image') {
      when { anyOf { branch 'main'; branch 'trial' } }
      steps {
        echo 'Building'
        sh 'docker build -t registry.lts.harvard.edu/lts/${imageName} .'
      }
    }

    // run test step
    // trial is optional and only goes to dev
    stage('Publish trial image') {
      when {
            branch 'trial'
        }
      steps {
        echo 'Pushing docker image to the registry...'
        echo "$GIT_TAG"
        script {
            if (GIT_TAG != "") {
                echo "$GIT_TAG"
                docker.withRegistry(registryUri, registryCredentialsId){
                def customImage = docker.build("registry.lts.harvard.edu/lts/${imageName}:$GIT_TAG")
                customImage.push()
                }
            } else {
                    echo "$GIT_HASH"
                    docker.withRegistry(registryUri, registryCredentialsId){
                    // this says build but its really just using the build from above and tagging it
                    def customImage = docker.build("registry.lts.harvard.edu/lts/${imageName}-snapshot:$GIT_HASH")
                    customImage.push()
                    def devImage = docker.build("registry.lts.harvard.edu/lts/${imageName}-snapshot:dev")
                    devImage.push()
                    }
            }
        }
      }
    }
    stage('TrialDevDeploy') {
      when {
          branch 'trial'
        }
      steps {
          echo "Deploying to dev"
          script {
              if (GIT_TAG != "") {
                  echo "$GIT_TAG"
                  sshagent(credentials : ['hgl_svcupd']) {
                      sh "ssh -t -t ${env.DEV_SERVER} '${env.RESTART_COMMAND} ${stackName}_${imageName}'"
                  }
              } else {
                      echo "$GIT_HASH"
                      sshagent(credentials : ['hgl_svcupd']) {
                      sh "ssh -t -t ${env.DEV_SERVER} '${env.RESTART_COMMAND} ${stackName}_${imageName}'"
                  }
              }
          }
      }
    }
   // test that dev is running, smoke tests
    // test that dev worked
    stage('Publish main dev image') {
      when {
            branch 'main'
        }
      steps {
        echo 'Pushing docker image to the registry...'
        echo "$GIT_TAG"
        script {
            if (GIT_TAG != "") {
                echo "$GIT_TAG"
                docker.withRegistry(registryUri, registryCredentialsId){
                def customImage = docker.build("registry.lts.harvard.edu/lts/${imageName}:$GIT_TAG")
                customImage.push()
                }
            } else {
                    echo "$GIT_HASH"
                    docker.withRegistry(registryUri, registryCredentialsId){
                    def customImage = docker.build("registry.lts.harvard.edu/lts/${imageName}-snapshot:$GIT_HASH")
                    customImage.push()
                    def devImage = docker.build("registry.lts.harvard.edu/lts/${imageName}-snapshot:dev")
                    devImage.push()
                    }
            }
        }
      }
    }
    stage('MainDevDeploy') {
      when {
          branch 'main'
        }
      steps {
          echo "Deploying to dev"
          script {
              if (GIT_TAG != "") {
                  echo "$GIT_TAG"
                  sshagent(credentials : ['hgl_svcupd']) {
                      sh "ssh -t -t ${env.DEV_SERVER} '${env.RESTART_COMMAND} ${stackName}_${imageName}'"
                  }
              } else {
                      echo "$GIT_HASH"
                      sshagent(credentials : ['hgl_svcupd']) {
                      sh "ssh -t -t ${env.DEV_SERVER} '${env.RESTART_COMMAND} ${stackName}_${imageName}'"
                  }
              }
          }
      }
    }
   //dev smoke tests
    stage('Publish main qa image') {
      when {
            branch 'main'
        }
      steps {
        echo 'Pushing docker image to the registry...'
        echo "$GIT_TAG"
        script {
            if (GIT_TAG != "") {
                echo "$GIT_TAG"
                docker.withRegistry(registryUri, registryCredentialsId){
                def customImage = docker.build("registry.lts.harvard.edu/lts/${imageName}:$GIT_TAG")
                customImage.push()
                }
            } else {
                    echo "$GIT_HASH"
                    docker.withRegistry(registryUri, registryCredentialsId){
                    def qaImage = docker.build("registry.lts.harvard.edu/lts/${imageName}-snapshot:qa")
                    qaImage.push()
                    }
            }
        }
      }
    }
    stage('MainQADeploy') {
      when {
          branch 'main'
        }
      steps {
          echo "Deploying to qa"
          script {
              if (GIT_TAG != "") {
                  echo "$GIT_TAG"
                  sshagent(credentials : ['qatest']) {
                      sh "ssh -t -t ${env.QA_SERVER} '${env.RESTART_COMMAND} ${stackName}_${imageName}'"
                  }
              } else {
                      echo "$GIT_HASH"
                      sshagent(credentials : ['qatest']) {
                      sh "ssh -t -t ${env.QA_SERVER} '${env.RESTART_COMMAND} ${stackName}_${imageName}'"
                  }
              }
          }
      }
    }
    // qa smoke tests
   }
   environment {
    imageName = 'spotlight'
    stackName = 'CURIOSITY'
    registryCredentialsId = "${env.REGISTRY_ID}"
    registryUri = 'https://registry.lts.harvard.edu'
   }
 }
