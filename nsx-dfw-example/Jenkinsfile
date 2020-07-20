pipeline {
    agent any
    stages {
        stage ("1. Terraform Init") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'NSX_Credentials', passwordVariable: 'pass', usernameVariable: 'user')]) {
                    sh '''
                        terraform init -var 'nsx_username='$user' -var 'nsx_password='$pass'
                        '''
                }
            }
        }
        stage ("2. Terraform Plan") {
            steps {
                sh terraform plan
            }
        }
        stage ("3. Terraform Apply") {
            steps {
                sh terraform apply -auto-approve
            }
        }
         stage ("4. Terraform Show") {
            steps {
                sh terraform show
            }
        }
    }
}
