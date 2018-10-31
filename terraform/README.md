# 概要



## 環境構築

### 設定

[config.tfvars](config.tfvars)の定数を変更します。

### IAMユーザ登録

terraform用のユーザーを作成します。

https://console.aws.amazon.com/iam/home

### 認証情報登録

AWS-CLIで作成したユーザの認証情報を登録します。

profile名は[main.tf](main.tf)で設定している値にしてください。

```bash
$ aws configure --profile ******
AWS Access Key ID [None]: ******************
AWS Secret Access Key [None]: ****************
Default region name [None]: ap-northeast-1
Default output format [None]: json
```

### GitHub OAuth token作成

CodePipeline構築時にGitHub OAuth tokenが必要になります。

repo全てにチェックを入れて作成してください。

https://github.com/settings/tokens

作成したtokenを環境変数に登録してください。
```bash
$ export GITHUB_TOKEN="**********"
```

### tfstate管理用環境構築

tfstateファイルをS3、lock管理をDynamoDBで行うため、
この環境のみ先に構築します。

バケット名、テーブル名は[main.tf](main.tf)の値を使用してください。
```hcl-terraform
bucket         = "*****-tfstate-bucket"
dynamodb_table = "*****-lock"
```

```bash
# tfstateファイル管理用のS3バケット作成
$ ./init_terraform_bucket.sh {バケット名}

# lock管理用テーブルを作成
$ ./init_terraform_lock_table.sh {テーブル名}
```

### terraform初期化

```bash
$ terraform init
```


### SSL証明書の作成

```bash
$ terraform apply --target=aws_acm_certificate.cert --var-file=config.tfvars
```

### CNAME設定

```bash
$ terraform console
```
```
> aws_acm_certificate.cert.domain_validation_options
[
  {
    "domain_name" = "*********"
    "resource_record_name" = "**********"
    "resource_record_type" = "CNAME"
    "resource_record_value" = "*********"
  },
]
>
```

### 残りの環境構築

```bash
$ terraform apply --var-file=config.tfvars
```

### DBパスワード
DBのパスワードはランダムな文字列を自動的に生成します。

下記のように出力されます。
```
random_string.password: Creation complete after 0s (ID: ********)
```

