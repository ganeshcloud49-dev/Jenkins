pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/ganeshcloud49-dev/Jenkins',
                    branch: 'main'
            }
        }

        stage('Select Action') {
            steps {
                script {
                    // Ask user whether to apply or destroy
                    action = input(
                        message: "What do you want to do with Terraform?",
                        parameters: [
                            choice(
                                name: 'ACTION',
                                choices: ['Apply', 'Destroy'],
                                description: 'Choose Terraform action'
                            )
                        ]
                    )
                    echo "You chose: ${action}"
                }
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'gkp-aws', 
                    usernameVariable: 'AWS_ACCESS_KEY_ID', 
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {

                    sh '''
                        export AWS_DEFAULT_REGION=ap-south-1
                        terraform init
                    '''

                    script {
                        if (action == 'Apply') {
                            sh 'terraform plan'
                        } else {
                            // For destroy, show what would be destroyed
                            sh 'terraform plan -destroy'
                        }
                    }
                }
            }
        }

        stage('Terraform Execute') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'gkp-aws', 
                    usernameVariable: 'AWS_ACCESS_KEY_ID', 
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {

                    script {
                        if (action == 'Apply') {
                            input message: "Do you want to apply Terraform changes?", ok: "Yes, Apply!"
                            sh '''
                                export AWS_DEFAULT_REGION=ap-south-1
                                terraform apply -auto-approve
                            '''
                        } else {
                            input message: "Do you want to destroy Terraform-managed resources?", ok: "Yes, Destroy!"
                            sh '''
                                export AWS_DEFAULT_REGION=ap-south-1
                                terraform destroy -auto-approve
                            '''
                        }
                    }
                }
            }
        }
    }
}
