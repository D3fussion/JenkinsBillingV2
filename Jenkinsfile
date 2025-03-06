pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/D3fussion/JenkinsBillingV2.git'
            }
        }
        
        stage('Build and Run Containers') {
            steps {
                script {
                    dir('/usr/bin/docker-compose') {
                    sh 'docker-compose up -d'
                    sh 'docker-compose --version'
                    sh 'docker-compose -f stack-billing.yml up -d --build'
                    }
                }
            }
        }

        stage('Test Database') {
            steps {
                script {
                    echo "Esperando que PostgreSQL esté listo..."
                    sh 'sleep 10'

                    sh '''
                    docker exec postgres pg_isready -U postgres
                    if [ $? -ne 0 ]; then
                        echo "PostgreSQL no está listo"
                        exit 1
                    fi
                    echo "PostgreSQL está listo"
                    '''
                }
            }
        }

        stage('Test Adminer') {
            steps {
                script {
                    echo "Esperando que Adminer esté disponible..."
                    sh 'sleep 10'
                    
                    sh 'curl -f http://localhost:9090 || exit 1'
                }
            }
        }

        stage('Test Backend') {
            steps {
                script {
                    echo "Esperando que el backend esté disponible..."
                    sh 'sleep 10'
                    sh 'curl -f http://localhost:8080/actuator/health || exit 1'
                }
            }
        }

stage('Test Frontend - Verificar Array en localhost:80') {
    steps {
        script {
            echo "Esperando que el frontend esté disponible..."
            sh 'sleep 10'

            sh '''
            RESPONSE=$(curl -s http://localhost:80)
            echo "Respuesta del frontend: $RESPONSE"

            # Verificar si la respuesta empieza con '['
            if echo "$RESPONSE" | grep -q '\\['; then
                echo "El frontend devolvió un array correctamente."
            else
                echo "ERROR: El frontend no devolvió un array."
                exit 1
            fi
            '''
        }
    }
}



        stage('Test Backend - Obtener Datos de /billing') {
            steps {
                script {
                    echo "Verificando endpoint del backend en /billing..."
                    sh 'sleep 10'

                    sh '''
                    RESPONSE=$(curl -s http://localhost:8080/billing)
                    echo "Respuesta de /billing: $RESPONSE"
                    '''
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    sh 'docker-compose -f stack-billing.yml down'
                }
            }
        }
    }
}
