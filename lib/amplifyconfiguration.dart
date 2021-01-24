const amplifyconfig = ''' {
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "UserAgent": "aws-amplify-cli/0.1.0",
        "Version": "0.1.0",
        "IdentityManager": {"Default": {}},
        "CredentialsProvider": {
            "CognitoIdentity": {
                "Default": {
                    "PoolId": "ap-northeast-1:******",
                    "Region": "ap-northeast-1"
                }
            }
        },
        "CognitoUserPool": {
          "Default": {
            "PoolId": "ap-northeast-1_******",
            "AppClientId": "******",
            "Region": "ap-northeast-1"
          }
        },
        "Auth": {
          "Default": {"authenticationFlowType": "USER_SRP_AUTH"}
        }
      }
    }
  }
}''';
