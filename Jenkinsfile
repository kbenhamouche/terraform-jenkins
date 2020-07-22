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

        stage ("1. Tf Init and Plan") {
            steps {
		sh "terraform init"
            }
        }
        
	stage ("credentials") {
		steps {
			script {
				withCredentials([usernamePassword(credentialsId: 'nsx_credentials', usernameVariable: 'USER', passwordVariable: 'PWD')]) {
		 		sh 'echo username= $USER'
		 		sh 'echo password= $PWD'	
			}
		}
	   }
	}
	stage ("2. tf Apply") {
		steps {
			script {
				withCredentials([usernamePassword(credentialsId: 'nsx_credentials', passwordVariable: 'PWD', usernameVariable: 'USER')]) {
                		 sh 'echo $USER'
				 sh 'echo $PWD'
				 sh "terraform plan -var 'nsx_username=$USER' -var 'nsx_password=$PWD'"
				 sh "terraform apply -auto-approve -var 'nsx_username='$user' -var 'nsx_password='$pass'"
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
