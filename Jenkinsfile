pipeline {
    agent any
    
    environment {
     NSX-CRED = credentials('nsx_credentials')
    }
    
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
				 sh "terraform plan -var 'nsx_username=$NSX-CRED_USR' -var 'nsx_password=$NSX-CRED_PSW'"
				 sh "terraform apply -auto-approve -var 'nsx_username=$NSX-CRED_USR' -var 'nsx_password=$NSX-CRED_PSW'"
                		
			}
		}
	}
	
	stage ("3. Tf Show") {
            steps {
                sh "terraform show"
            }
        }

	stage ("4. run Tf destroy?") {
            steps {
                input 'do you want to destroy the setup?'
            }
        }

	stage ("5. Tf destroy") {
            steps {
			script {
				withCredentials([usernamePassword(credentialsId: 'nsx_credentials', passwordVariable: 'PWD', usernameVariable: 'USER')]) {
				sh "terraform destroy -force -var 'nsx_username=$USER' -var 'nsx_password=$PWD'"
            			}
			}
            }
	}
    }
}
