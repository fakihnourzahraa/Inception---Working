Database tests
# Create test table and insert data
sudo docker exec mariadb mysql -u wpuser -p"wp_secure_password_456" wordpress -e "CREATE TABLE IF NOT EXISTS persistence_test (id INT, message VARCHAR(255)); INSERT INTO persistence_test VALUES (1, 'Does this survive a restart?');"

# View the data
sudo docker exec mariadb mysql -u wpuser -p"wp_secure_password_456" wordpress -e "SELECT * FROM persistence_test;"

# Drop (delete) the table
sudo docker exec mariadb mysql -u wpuser -p"wp_secure_password_456" wordpress -e "DROP TABLE persistence_test;"

# Verify it's gone (returns error - expected)
sudo docker exec mariadb mysql -u wpuser -p"wp_secure_password_456" wordpress -e "SELECT * FROM persistence_test;"