pipeline {
  agent { label 'master' }
  parameters {
    string(name: 'GIBS_URL', defaultValue: 'http://172.16.73.120:9080/eibs_biq_web', description: 'GIBS URL')
    string(name: 'GIBS_USER', defaultValue: 'Biqplat', description: 'Main user for tests')
    string(name: 'GIBS_PASSWORD', defaultValue: 'ingreso2', description: 'Password for Main user')
    string(name: 'GIBS_SIGNATORY_USER', defaultValue: 'Biqbanco', description: 'Signatory user for tests')
    string(name: 'GIBS_SIGNATORY_PASSWORD', defaultValue: 'ingreso1', description: 'Password for signatory user')
    booleanParam(name:'LOGIN', defaultValue:false, description:'Run login tests')

    booleanParam(name:'NATURAL_CLIENTS', defaultValue:false, description:'Run Tests for Clients')
    booleanParam(name:'LEGAL_CLIENTS', defaultValue:false, description:'Run Tests for Clients')
    booleanParam(name:'BANK_CLIENTS', defaultValue:false, description:'Run Tests for Clients')
    booleanParam(name:'BUISNESS_RULES', defaultValue:false, description:'Run Tests for Clients')
    
    text(name: 'INITIAL_CLIENTS', defaultValue: '', description: 'Clients to be used in testing')
    text(name: 'INITIAL_CHECKACCOUNTS', defaultValue: '', description: 'Clients to be used in testing')
    text(name: 'INITIAL_DEBITCARDS', defaultValue: '', description: 'Debit Cards to be used in testing')
    text(name: 'INITIAL_SAVINGACCOUNTS', defaultValue: '', description: 'Check Accounts to be used in testing')
    text(name: 'INITIAL_CERTIFICATES', defaultValue: '', description: 'Saving Accounts to be used in testing')
    text(name: 'INITIAL_LOCKERS', defaultValue: '', description: 'Check Accounts with funds to be used in initial lockers')
    
    booleanParam(name:'EXTRA_CLIENTES', defaultValue:false, description:'Attempt to create extra clients needed for testing')
    booleanParam(name:'EXTRA_CHECK_ACCOUNTS', defaultValue:false, description:'Attempt to create extra check accounts needed for testing')
    booleanParam(name:'EXTRA_SAVING_ACCOUNTS', defaultValue:false, description:'Attempt to create extra saving accounts needed for testing')
    
    booleanParam(name:'CHECK_ACCOUNTS', defaultValue:false, description:'Run Tests for Checks and Chekbooks Administration')
    booleanParam(name:'CHECK_CARDS', defaultValue:false, description:'Run Tests for Current Account and Debit Cards')
    booleanParam(name:'SAVINGS_ACCOUNT', defaultValue:false, description:'Run Tests for Savings Account')
    booleanParam(name:'DEPOSIT_CERTIFICATE', defaultValue:false, description:'Run Tests for Deposit Certificate')
    booleanParam(name:'EXTRA_SERVICES', defaultValue:false, description:'Consolidated Position, Valued Species, Security Locker')
    
    booleanParam(name:'CREDIT_PROPOSAL_PRODUCTIVE_NATURAL', defaultValue:false, description:'Run Tests for Credit Proposal - Productive for Natural Clients')
    booleanParam(name:'CREDIT_PROPOSAL_MICROCREDIT_NATURAL', defaultValue:false, description:'Run Tests for Credit Proposal - Microcredit for Natural Clients')
    booleanParam(name:'CREDIT_PROPOSAL_REAL_STATE', defaultValue:false, description:'Run Tests for Credit Proposal - Real State')
    booleanParam(name:'CREDIT_PROPOSAL_CONSUMPTION', defaultValue:false, description:'Run Tests for Credit Proposal - Consumption')
    booleanParam(name:'CREDIT_PROPOSAL_PRODUCTIVE_LEGAL', defaultValue:false, description:'Run Tests for Credit Proposal - Productive for Legal Clients')
    booleanParam(name:'CREDIT_PROPOSAL_MICROCREDIT_LEGAL', defaultValue:false, description:'Run Tests for Credit Proposal - Microcredit for Legal Clients')
    booleanParam(name:'CREDIT_LINES', defaultValue:false, description:'Run Tests for Credit Proposal - Credit Lines')
    booleanParam(name:'OVERDRAFT', defaultValue:false, description:'Run Tests for Overdrafts')
    booleanParam(name:'GUARANTEES', defaultValue:false, description:'Run Tests for Guarantees')
    booleanParam(name:'RUN_ONCE', defaultValue:false, description:'Run single execution tests')
    }
  options {
    buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '20', daysToKeepStr: '20'))
    disableConcurrentBuilds()
  }
  environment {
    TESTS_VARIABLES = credentials('tests_variables')
  }

  stages {
    stage('Preparing Env for Tests') {
      steps {
        sh "git clean -dfx"
        script {
          imageForTests = docker.build("bietests:${env.BUILD_ID}", ".")
          imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
            sh 'mkdir results'
            sh 'mkdir _data-generation'

            sh 'touch ./_data-generation/clients.txt'
            sh '/bin/echo -e $INITIAL_CLIENTS >> ./_data-generation/clients.txt'
            sh "sed -i 's,}[ ]*{,}\\n{,g' ./_data-generation/clients.txt"
            sh '/bin/echo -e \'\' >> ./_data-generation/clients.txt'
            
            sh 'touch ./_data-generation/checkAccounts.txt'
            sh '/bin/echo -e $INITIAL_CHECKACCOUNTS >> ./_data-generation/checkAccounts.txt'
            sh "sed -i 's,}[ ]*{,}\\n{,g' ./_data-generation/checkAccounts.txt"
            sh '/bin/echo -e \'\' >> ./_data-generation/checkAccounts.txt'

            sh 'touch ./_data-generation/savingAccounts.txt'
            sh '/bin/echo -e $INITIAL_SAVINGACCOUNTS >> ./_data-generation/savingAccounts.txt'
            sh "sed -i 's,}[ ]*{,}\\n{,g' ./_data-generation/savingAccounts.txt"
            sh '/bin/echo -e \'\' >> ./_data-generation/savingAccounts.txt'

            sh 'touch ./_data-generation/debitCards.txt'
            sh '/bin/echo -e $INITIAL_DEBITCARDS >> ./_data-generation/debitCards.txt'
            sh "sed -i 's,}[ ]*{,}\\n{,g' ./_data-generation/debitCards.txt"
            sh '/bin/echo -e \'\' >> ./_data-generation/debitCards.txt'

            sh 'touch ./_data-generation/depositCertificates.txt'
            sh '/bin/echo -e $INITIAL_CERTIFICATES >> ./_data-generation/depositCertificates.txt'
            sh "sed -i 's,}[ ]*{,}\\n{,g' ./_data-generation/depositCertificates.txt"
            sh '/bin/echo -e \'\' >> ./_data-generation/depositCertificates.txt'

            sh 'touch ./_data-generation/lockers.txt'
            sh '/bin/echo -e $INITIAL_LOCKERS >> ./_data-generation/lockers.txt'
            sh "sed -i 's,}[ ]*{,}\\n{,g' ./_data-generation/lockers.txt"
            sh '/bin/echo -e \'\' >> ./_data-generation/lockers.txt'

            sh 'cp $TESTS_VARIABLES .env'
            sh "sed -i 's,^GIBS_BASE_URL=.*,GIBS_BASE_URL=$GIBS_URL,' .env"
            sh "sed -i 's,^GIBS_E2E_USER=.*,GIBS_E2E_USER=$GIBS_USER,' .env"
            sh "sed -i 's,^GIBS_E2E_PASSWORD=.*,GIBS_E2E_PASSWORD=$GIBS_PASSWORD,' .env"
            sh "sed -i 's,^SIGNATORY_ACCESS_GIBS_E2E_USER=.*,SIGNATORY_ACCESS_GIBS_E2E_USER=$GIBS_SIGNATORY_USER,' .env"
            sh "sed -i 's,^SIGNATORY_ACCESS_GIBS_E2E_PASSWORD=.*,SIGNATORY_ACCESS_GIBS_E2E_PASSWORD=$GIBS_SIGNATORY_PASSWORD,' .env"
            
            sh "yarn install"
          }
        }
      }
    }
    stage("Running Login Tests") {
      when { expression { params.LOGIN } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite login"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/login; fi"
        }
      }
    }
    stage("Running Tests for Natural Clients") {
      when { expression { params.NATURAL_CLIENTS } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite naturalClients"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/natural-Clients; fi"
        }
      }
    }
    stage("Running Tests for Legal Clients") {
      when { expression { params.LEGAL_CLIENTS } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite legalClients"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/legal-Clients; fi"
        }
      }
    }
    stage("Running Tests for Bank Clients") {
      when { expression { params.BANK_CLIENTS } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite bankClients"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/bank-Clients; fi"
        }
      }
    }
    stage("Running Tests for Client's Buisness Rules") {
      when { expression { params.BUISNESS_RULES } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite clientsBusinessRules"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/clients-Business-Rules; fi"
        }
      }
    }

    stage("Creating basic clients") {
      when { expression { params.EXTRA_CLIENTES } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite basicClients"
            }
          }
        }
      }
    }
    stage("Creating a prospect") {
      when { expression { params.EXTRA_CLIENTES } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite prospect"
            }
          }
        }
      }
    }
    stage("Creating custom clients (ong, underage, financial...)") {
      when { expression { params.EXTRA_CLIENTES } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite specificClients"
            }
          }
        }
      }
    }
    stage("Approving pending clients") {
      when { expression { params.EXTRA_CLIENTES } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite approveClients"
            }
          }
        }
      }
    }

    stage("Creating checks Accounts") {
      when { anyOf {
        expression { params.CHECK_ACCOUNTS } 
        expression { params.EXTRA_CHECK_ACCOUNTS } 
        }
      }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite openCheckAccounts"
            }
          }
        }
      }
    }
    stage("Approving checks Accounts") {
      when { anyOf {
        expression { params.CHECK_ACCOUNTS } 
        expression { params.EXTRA_CHECK_ACCOUNTS } 
        }
      }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite approveCheckAccounts"
            }
          }
        }
      }
    }

    stage("Running Tests for checkbook administration") {
      when { expression { params.CHECK_ACCOUNTS } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite checksAdministration"
              sh "yarn test-ci --suite checksIssue"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/checksAdministration; fi"
        }
      }
    }
    
    stage("Running Tests for Checks Accounts card request") {
      when { expression { params.CHECK_CARDS } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite currentAccount"
            }
          }
        }
      }
    }
    stage("Running Tests for Checks Accounts cards assignation") {
      when { expression { params.CHECK_CARDS } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite approveCheckAccounts"
            }
          }
        }
      }
    }
    stage("Running Tests for Checks Accounts and cards assignation") {
      when { expression { params.CHECK_CARDS } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite debitCards"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/checksCards; fi"
        }
      }
    }
    stage("Creating basic savings Account") {
      when { 
        anyOf {
          expression { params.SAVINGS_ACCOUNT } 
          expression { params.EXTRA_SAVING_ACCOUNTS } 
        }
      }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite savingAccountsBasic"
            }
          }
        }
      }
    }

    stage("Conditional Savings Account") {
      when { expression { params.SAVINGS_ACCOUNT } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite savingAccountsDetailed"
            }
          }
        }
      }
    }
    stage("Savings Account, pad cancellation and additional cases") {
      when { expression { params.SAVINGS_ACCOUNT } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite savingAccountsAdditionalCases"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/savings-account; fi"
        }
      }
    }
    stage("Savings Account, Signatories, approval and maintenance") {
      when { expression { params.SAVINGS_ACCOUNT } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite signatories"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/signatories; fi"
        }
      }
    }
    stage("Running Tests for Deposit Certificate") {
      when { expression { params.DEPOSIT_CERTIFICATE } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite deposits"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/deposit-certificate; fi"
        }
      }
    }
    stage("Running Tests for Deposit Certificate: Opening with discretional rate and value date") {
      when { expression { params.DEPOSIT_CERTIFICATE } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite depositsSpecialCases"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/deposit-certificate-special-cases; fi"
        }
      }
    }
    stage("Running: Values Species: request, cancellation") {
      when { expression { params.EXTRA_SERVICES } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite valuedSpecies"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/valued-species; fi"
        }
      }
    }
    stage("Running: Consolidated Position") {
      when { expression { params.EXTRA_SERVICES } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite consolidatedPosition"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/consolidated-position; fi"
        }
      }
    }
    stage("Running: Security Locker, oppenning, authorizaed persons assignation, cancelling") {
      when { expression { params.EXTRA_SERVICES } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite securityLocker"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/security-locker; fi"
        }
      }
    }
    stage("Running Tests for Credit Proposal - Microcredit (Natural Clients)") {
      when { expression { params.CREDIT_PROPOSAL_MICROCREDIT_NATURAL } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite creditProposalMicrocreditNatural -k retailer"
            }
          }
        }
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite creditProposalMicrocreditNatural -k simple_accumulation"
            }
          }
        }
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite creditProposalMicrocreditNatural -k extended_accumulation"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/credit-proposal-microcredit-natural; fi"
        }
      }
    }
    stage("Running Tests for Credit Proposal - Productive (Natural Clients)") {
      when { expression { params.CREDIT_PROPOSAL_PRODUCTIVE_NATURAL } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite creditProposalProductiveNatural -k pymes"
            }
          }
        }
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite creditProposalProductiveNatural -k bussiness"
            }
          }
        }
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite creditProposalProductiveNatural -k corporative"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/credit-proposal-productive-natural; fi"
        }
      }
    }
    stage("Running Tests for Credit Proposal - Microcredit (Legal Clients)") {
      when { expression { params.CREDIT_PROPOSAL_MICROCREDIT_LEGAL } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite creditProposalMicrocreditLegal -k retailer"
            }
          }
        }
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite creditProposalMicrocreditLegal -k simple_accumulation"
            }
          }
        }
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite creditProposalMicrocreditLegal -k extended_accumulation"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/credit-proposal-microcredit-legal; fi"
        }
      }
    }
    stage("Running Tests for Credit Proposal - Productive (Legal Clients)") {
      when { expression { params.CREDIT_PROPOSAL_PRODUCTIVE_LEGAL } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite creditProposalProductiveLegal -k pymes"
            }
          }
        }
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite creditProposalProductiveLegal -k bussiness"
            }
          }
        }
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite creditProposalProductiveLegal -k corporative"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/credit-proposal-productive-legal; fi"
        }
      }
    }
    stage("Running Tests for Credit Proposal - Real State") {
      when { expression { params.CREDIT_PROPOSAL_REAL_STATE } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite creditProposalRealEstate"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/credit-proposal-real-state; fi"
        }
      }
    }
    stage("Running Tests for Credit Proposal - Consumption") {
      when { expression { params.CREDIT_PROPOSAL_CONSUMPTION } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite creditProposalConsumption"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/credit-proposal-consumption; fi"
        }
      }
    }
    
    stage("Running Tests for Credit line Proposals") {
      when { expression { params.CREDIT_LINES } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite creditLines"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/credit-lines; fi"
        }
      }
    }
    stage("Running Tests for Overdrafts") {
      when { expression { params.OVERDRAFT } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite overdraft"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/overdraft; fi"
        }
      }
    }
    stage("Running Tests for Guarantees") {
      when { expression { params.GUARANTEES } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn test-ci --suite guarantees"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/guarantees; fi"
        }
      }
    }
    stage("Running singe execution tests") {
      when { expression { params.RUN_ONCE } }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          script {
            imageForTests.inside("-v ${HOME}/yarn-cache:${HOME}/.cache/yarn") {
              sh "yarn testOnce-ci"
            }
          }
        }
      }
      post {
        always {
          sh "if [ -d \"./reports\" ]; then mv ./reports ./results/run-once; fi"
        }
      }
    }
  }
  post {
    always {
      script {
          sh "mv ./_data-generation ./results"
      }
      archiveArtifacts artifacts: 'results\\**\\*', onlyIfSuccessful: false
      script {
        sh "docker image rm bietests:${env.BUILD_ID}"
      }
    }
  }
}
