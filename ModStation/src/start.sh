# 若脚本不可执行,请转为 unix 格式
mkdir -p /var/mywork/modbus

docker run -d \
  --name modbus \
  --restart=always \
  --privileged \
  -p 5502:5502 \
  -v /var/mywork/modbus:/app/cfg/ \
docker.runsoft.online:5000/local/modstation