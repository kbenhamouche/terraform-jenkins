pipeline {
    agent any

    triggers {
     githubPush()
    }

    stages {
	stage(" -- Set Terraform path --") {
 	  steps {
 	    script {
		def tfHome = tool name: 'Terraform'
 		env.PATH = "${tfHome}:${env.PATH}"
 	    }
 	    sh 'terraform -version'
	  }
	}

        stage ("1. Tf Init") {
            steps {
		sh "terraform init"
            }
        }
        
	stage ("2. Tf Plan and Apply") {
		steps {
			script {
				withCredentials([usernamePassword(credentialsId: 'nsx_credentials', passwordVariable: 'PWD', usernameVariable: 'USER')]) {
				 sh "terraform plan -var 'nsx_username=$USER' -var 'nsx_password=$PWD'"
				 sh "terraform apply -auto-approve -var 'nsx_username=$USER' -var 'nsx_password=$PWD'"
                		}
			}
		}
	}
	
	stage ("3. Tf Show") {
            steps {
                sh "terraform show"
            }
        }
    }
}
