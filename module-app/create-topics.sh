
kafka-topics --create --bootstrap-server bitnami-kafka-headless:9092 --replication-factor 1 --partitions 1 --topic bankaccConsumer --delete --if-exists

kafka-topics --create --bootstrap-server bitnami-kafka-headless:9092 --replication-factor 1 --partitions 1 --topic bankaccConsumer --create --if-not-exists
