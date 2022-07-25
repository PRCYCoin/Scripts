echo "Updating/Upgrading OS..."
sudo apt update && sudo apt upgrade -y
cd prcy-seeder
echo "Pulling Latest Source From GitHub..."
git pull
echo "Compiling..."
make
echo "Stopping Service..."
sudo systemctl stop prcy-seeder.service
echo "Stopping Service..."
sudo cp dnsseed /usr/local/bin
echo "Stopping Service..."
sudo systemctl start prcy-seeder.service
echo "PRCY Seed Node updated successfully!"