pipeline {
    agent any 
    environment {
        git_url = 'https://github.com/shankar7773/LTI_CICD_DEMO.git'
        build_no = "${env.BUILD_NUMBER}"
        nex_cred = 'Nexus_Credentials'
        grp_ID = 'project2'
        nex_url = '44.203.72.62:8081'
        nex_ver = 'nexus3'
        proto = 'http'
        remote_name = 'ec2-user'
        remote_host = '44.204.75.113'
    }
    stages {
    stage('Clone repo'){
        steps {
            git credentialsId:'shankar7773' , url:"${git_url}"
            echo " Clone repo done !!"
    }
    }

    stage('Maven Build'){
        steps {
            script{
        def mavenHome = tool name: "Maven", type: "maven"
        def mavenCMD = "${mavenHome}/bin/mvn"
        sh "${mavenCMD} clean package"
        echo " Build Completed !!!"
    }
    }
    }
 /*   stage('SonarQube analysis') {  
        steps {
            script {
        withSonarQubeEnv('Sonar') {
       	def mavenHome = tool name: "Maven", type: "maven"
        def mavenCMD = "${mavenHome}/bin/mvn"
        sh "${mavenCMD} sonar:sonar"  
        echo " Analysis !!"
        }
        }
    }
    } */
    
    stage('Upload Build Artifact'){
        steps{
            script {
        def mavenpom = readMavenPom file: 'pom.xml'
        nexusArtifactUploader artifacts: [[artifactId: '01-maven-web-app', classifier: '', file: 'target/01-maven-web-app.war', type: 'war']], credentialsId: "${env.nex_cred}", groupId: "${grp_ID}", nexusUrl: "${nex_url}", nexusVersion: "${nex_ver}" , protocol: "${proto}", repository: 'project2', version: "${mavenpom.version}-${build_no}"
        echo " Artifact Uploaded !!"
            }
        }
    }
    
    stage('Docker Image Build'){
        steps{
            withCredentials([usernamePassword(credentialsId: 'Nex_Docker', passwordVariable: 'nex', usernameVariable: 'nex_user')]){
                            script {
                def mavenpom = readMavenPom file: 'pom.xml'
                def artifactId= '01-maven-web-app'
                def tag = mavenpom.version;
          
        sh """
        docker build --build-arg pass=${nex} --build-arg user_nex=${nex_user} --build-arg artifact_id=${artifactId} --build-arg host_name="${nex_url}" --build-arg version=${tag} --build-arg build_no="${build_no}" -t shankar7773/tomcat:"${tag}"-"${build_no}" .
        """
        }
                
            }
        }
    }
    
    stage('Upload image to DockerHub'){
        steps{
            withCredentials([usernamePassword(credentialsId: 'Dockerhub1', passwordVariable: 'pp', usernameVariable: 'uu')]) {
            script {
                def mavenpom = readMavenPom file: 'pom.xml'
                def tag = mavenpom.version;
        sh """ docker login -u ${uu} -p ${pp}
        docker image push shankar7773/tomcat:"${tag}"-"${build_no}"
        docker rmi shankar7773/tomcat:"${tag}"-"${build_no}"
        """
}
            }
        }
    }
    
   /* stage('Transfer pom.xml file on remote server') {
            steps{
            withCredentials([sshUserPrivateKey(credentialsId: 'k8s', keyFileVariable: 'private', passphraseVariable: 'provate', usernameVariable: 'ubuntu')])
            {
                script{
                    def remote = [:]
                    remote.name = "${ubuntu}"
                    remote.host = '100.26.191.255'
                    remote.user = "${ubuntu}"
                    remote.password = "${private}"
                    remote.allowAnyHosts = true
                    sshPut remote: remote, from: '/var/lib/jenkins/workspace/Project1/pom.xml', into: '.'
                }
            }
            }
    } */
    
    stage('Deploy Application on k8s Cluster'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'Dockerhub1', passwordVariable: 'pp', usernameVariable: 'uu')]){
                script{
                    sshagent(['k8']) {
                     //  def mavenpom = readMavenPom file: 'pom.xml'
                      // def artifactId= 'helloworld'
                      // def tag = "${mavenpom.version}"
                       sh "docker login -u ${uu} -p ${pp}"
                      // sh "sed -i 's/tag/${tag}-${build_no}/g' Deployment.yaml"
                      // sh "sudo cp Deployment.yaml /home/ubuntu/"
                       sh "ssh -o StrictHostKeyChecking=no -l ubuntu 172.31.89.114 sudo kubectl apply -f Deployment.yaml"
                       sh "ssh -o StrictHostKeyChecking=no -l ubuntu 172.31.89.114 sudo kubectl apply -f service.yaml"
                       sh "ssh -o StrictHostKeyChecking=no -l ubuntu 172.31.89.114 sudo kubectl get all"
                    }
}
                }
            }
    }
    
   /* stage('Transfer pom.xml file on remote server') {
            steps{
            withCredentials([usernamePassword(credentialsId: 'anisble_host', passwordVariable: 'remote_password', usernameVariable: 'remote_user')])
            {
                script{
                    def remote = [:]
                    remote.name = "${remote_name}"
                    remote.host = "${remote_host}"
                    remote.user = "${remote_user}"
                    remote.password = "${remote_password}"
                    remote.allowAnyHosts = true
                    sshPut remote: remote, from: '/var/lib/jenkins/workspace/Project1/pom.xml', into: '.'
                }
            }
            }
    }
    
    stage('Ansible Deployment'){
        steps{
            script{
                sshagent(['Ansible']) {
    sh 'ssh -o StrictHostKeyChecking=no -l ansible 44.204.75.113 ansible-playbook tomcat.yml --vault-password-file vault_password_file'
}
            }
        }
    } */

    }
}
