#!/bin/bash
set -e

echo "=== START CONTAINER ==="

service ssh start

# пользователь
if ! getent group alex >/dev/null; then
  groupadd alex
fi

if ! id alex >/dev/null 2>&1; then
  useradd -m -s /bin/bash -g alex alex
  echo 'alex:273996091909090' | chpasswd
  echo 'alex ALL=(ALL) ALL' >> /etc/sudoers
fi

chown -R alex:alex /opt/hadoop
chown -R alex:alex /opt/hadoop/logs

# используем уже готовый JAVA_HOME
sed -i "s|^export JAVA_HOME=.*|export JAVA_HOME=$JAVA_HOME|" /opt/hadoop/etc/hadoop/hadoop-env.sh

# SSH
su - alex << 'EOF'
mkdir -p ~/.ssh
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
ssh-keyscan -H localhost >> ~/.ssh/known_hosts
ssh-keyscan -H hadoop >> ~/.ssh/known_hosts
EOF

# форматирование
if [ ! -d /opt/hadoop/data/namenode/current ]; then
  echo "=== FORMAT HDFS ==="
  su - alex -c "/opt/hadoop/bin/hdfs namenode -format -force"
fi

# запуск
echo "=== START HADOOP ==="
su - alex -c "/opt/hadoop/sbin/start-dfs.sh"
su - alex -c "/opt/hadoop/sbin/start-yarn.sh"

echo "=== HADOOP STARTED ==="

tail -f /dev/null