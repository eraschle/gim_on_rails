# start neo4j server
sudo service neo4j stop
cd /var/lib/neo4j
# => important "/*": deletes schema, but NOT login
sudo rm -rf data/databases/*
sudo service neo4j start

