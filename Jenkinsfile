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
		withCredentials([usernamePassword(credentialsId: 'nsx_credentials', usernameVariable: 'username', passwordVariable: 'password')]) {
		 sh 'echo username= $username'
		 sh 'echo password= $password'	
		}
		}
	   }
	}
	stage ("2. tf Apply") {
		steps {
			script {
				withCredentials([usernamePassword(credentialsId: 'nsx_credentials', passwordVariable: 'pass', usernameVariable: 'user')]) {
                		 sh 'echo $user'
				 sh 'echo $pass'
				 sh "terraform plan -var 'nsx_username='$user' -var 'nsx_password='$pass'"
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
