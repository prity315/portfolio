resource "aws_iam_user" "user" {
  name          = "${module.sso_login_backend_label.id}-${var.user_name}"
  path          = "/"
  force_destroy = true

  tags = module.sso_login_backend_label.tags
}

resource "aws_iam_policy" "user_policy" {
  name   = "${module.sso_login_backend_label.id}-user-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
            "cognito-idp:AddCustomAttributes",
            "cognito-idp:AdminAddUserToGroup",
            "cognito-idp:AdminConfirmSignUp",
            "cognito-idp:AdminCreateUser",
            "cognito-idp:AdminDisableProviderForUser",
            "cognito-idp:AdminDisableUser",
            "cognito-idp:AdminEnableUser",
            "cognito-idp:AdminForgetDevice",
            "cognito-idp:AdminGetDevice",
            "cognito-idp:AdminGetUser",
            "cognito-idp:AdminInitiateAuth",
            "cognito-idp:AdminLinkProviderForUser",
            "cognito-idp:AdminListDevices",
            "cognito-idp:AdminListGroupsForUser",
            "cognito-idp:AdminListUserAuthEvents",
            "cognito-idp:AdminRemoveUserFromGroup",
            "cognito-idp:AdminResetUserPassword",
            "cognito-idp:AdminRespondToAuthChallenge",
            "cognito-idp:AdminSetUserMFAPreference",
            "cognito-idp:AdminSetUserPassword",
            "cognito-idp:AdminSetUserSettings",
            "cognito-idp:AdminUpdateAuthEventFeedback",
            "cognito-idp:AdminUpdateDeviceStatus",
            "cognito-idp:AdminUpdateUserAttributes",
            "cognito-idp:AdminUserGlobalSignOut",
            "cognito-idp:AssociateSoftwareToken",
            "cognito-idp:ChangePassword",
            "cognito-idp:ConfirmDevice",
            "cognito-idp:ConfirmForgotPassword",
            "cognito-idp:ConfirmSignUp",
            "cognito-idp:CreateGroup",
            "cognito-idp:CreateIdentityProvider",
            "cognito-idp:CreateResourceServer",
            "cognito-idp:CreateUserImportJob",
            "cognito-idp:CreateUserPool",
            "cognito-idp:CreateUserPoolClient",
            "cognito-idp:CreateUserPoolDomain",
            "cognito-idp:DescribeIdentityProvider",
            "cognito-idp:DescribeResourceServer",
            "cognito-idp:DescribeRiskConfiguration",
            "cognito-idp:DescribeUserImportJob",
            "cognito-idp:DescribeUserPool",
            "cognito-idp:DescribeUserPoolClient",
            "cognito-idp:DescribeUserPoolDomain",
            "cognito-idp:ForgetDevice",
            "cognito-idp:ForgotPassword",
            "cognito-idp:GetCSVHeader",
            "cognito-idp:GetDevice",
            "cognito-idp:GetGroup",
            "cognito-idp:GetIdentityProviderByIdentifier",
            "cognito-idp:GetSigningCertificate",
            "cognito-idp:GetUICustomization",
            "cognito-idp:GetUser",
            "cognito-idp:GetUserAttributeVerificationCode",
            "cognito-idp:GetUserPoolMfaConfig",
            "cognito-idp:GlobalSignOut",
            "cognito-idp:InitiateAuth",
            "cognito-idp:ListDevices",
            "cognito-idp:ListGroups",
            "cognito-idp:ListIdentityProviders",
            "cognito-idp:ListResourceServers",
            "cognito-idp:ListTagsForResource",
            "cognito-idp:ListUserImportJobs",
            "cognito-idp:ListUserPoolClients",
            "cognito-idp:ListUserPools",
            "cognito-idp:ListUsers",
            "cognito-idp:ListUsersInGroup",
            "cognito-idp:ResendConfirmationCode",
            "cognito-idp:RespondToAuthChallenge",
            "cognito-idp:SetRiskConfiguration",
            "cognito-idp:SetUICustomization",
            "cognito-idp:SetUserMFAPreference",
            "cognito-idp:SetUserPoolMfaConfig",
            "cognito-idp:SetUserSettings",
            "cognito-idp:SignUp",
            "cognito-idp:StartUserImportJob",
            "cognito-idp:StopUserImportJob",
            "cognito-idp:TagResource",
            "cognito-idp:UntagResource",
            "cognito-idp:UpdateAuthEventFeedback",
            "cognito-idp:UpdateDeviceStatus",
            "cognito-idp:UpdateGroup",
            "cognito-idp:UpdateIdentityProvider",
            "cognito-idp:UpdateResourceServer",
            "cognito-idp:UpdateUserAttributes",
            "cognito-idp:UpdateUserPool",
            "cognito-idp:UpdateUserPoolClient",
            "cognito-idp:UpdateUserPoolDomain",
            "cognito-idp:VerifySoftwareToken",
            "cognito-idp:VerifyUserAttribute",
            "sqs:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
EOF
}

resource "aws_iam_user_policy_attachment" "cf_policy_attachment" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.user_policy.arn
}

resource aws_iam_access_key "user_access_key" {
  user = aws_iam_user.user.name
}