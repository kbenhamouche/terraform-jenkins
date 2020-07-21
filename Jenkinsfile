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
		sh "terraform plan"
            }
        }
        
        
	stage ("2. tf Apply") {
		steps {
			withCredentials([usernamePassword(credentialsId: 'NSX_Credentials', passwordVariable: 'pass', usernameVariable: 'user')]) {
                		sh "terraform apply -auto-approve -var 'nsx_username='$user' -var 'nsx_password='$pass'"
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
