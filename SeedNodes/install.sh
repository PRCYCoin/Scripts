cd
echo "Checking for updates..."
sudo apt update
echo "Applying any available upgrades..."
sudo apt upgrade -y
echo "Installing dependencies..."
sudo apt install build-essential libboost-dev libssl-dev -y
echo "Cloning Git Repo..."
git clone https://github.com/PRCYCoin/generic-seeder.git
echo "Building seeder..."
cd prcy-seeder
make
echo "Installing to /usr/local/bin..."
sudo cp dnsseed /usr/local/bin
echo "Editing seeder service..."
nano contrib/init/prcy-seeder.service
echo "Installing seeder service..."
sudo cp contrib/init/prcy-seeder.service /etc/systemd/system/
echo "Starting seeder service..."
sudo systemctl start prcy-seeder.service
sudo systemctl enable prcy-seeder.service
echo "Done!"