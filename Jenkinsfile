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
                withCredentials([usernamePassword(credentialsId: 'NSX_Credentials', passwordVariable: 'pass', usernameVariable: 'user')]) {
		sh "terraform init -var 'nsx_username='$user' -var 'nsx_password='$pass'"
                }
            }
        }
        stage ("2. Tf Plan") {
            steps {
                sh "terraform plan"
            }
        }
        stage ("3. Tf Apply") {
            steps {
                sh "terraform apply -auto-approve"
            }
        }
         stage ("4. Tf Show") {
            steps {
                sh "terraform show"
            }
        }
    }
}
