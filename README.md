# EC2+FastAPIのサンプル

## 構成

1. 2つのAZ(ap-northeast-1a,1c)にまたがる1つのVPC. VPCにはInternet Gateway
2. それぞれのAZにPublic/Privateのサブネット
3. 2.のパブリックサブネットにはそれぞれNAT Gateway
4. ap-northeast-1aのpublic subnetには踏み台サーバ(EC2 t2.micro)
5. ap-northeast-1a,1cのprivate subnetにはそれぞれアプリサーバ(EC2 t2.micro Pythonのfastapi)
6. 4.の踏み台サーバには, 指定したキーペアを持つ外部からSSH接続可能.

## TODO

- リソース名の付与
- サーバへのSSH確認
- FastAPIの動作確認
- diagram
- ALB
- CI/CD
