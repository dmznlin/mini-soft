# 若脚本不可执行,请转为 unix 格式

docker run -d \
  --name modbus \
  --restart=always \
  --privileged \
  -p 8802:80 \
  -v /var/mywork/modbus:/app/cfg/ \
docker.runsoft.online:5000/local/modstation