# 若脚本不可执行,请转为 unix 格式
mkdir -p /var/mywork/mqttunnel

docker run -d \
  --name mqttunnel \
  --restart=always \
  --network=host \
  -v /var/mywork/mqttunnel:/app/cfg/ \
docker.runsoft.online:5000/local/mqttunnel:arm