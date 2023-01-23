# Notes for setting up Quorum on an M1
 - Machine was erased and Moterery 12.4 was installed fresh. At this point the machine is fully updated.
 - Xcode Developer Tools is installed from the Mac App Store. Version is 13.4.

## Docker with colima
We *must* use the aarch versions, so this is done by first installing brew. Brew is only supported in `/opt/homebrew` on M1's

```zsh
# Homebrew tools must be first in PATH
path=(/opt/homebrew/bin $path)

# Install aarch versions of colima and docker client
brew install colima docker docker-compose

# Create and install colima with proper settings
colima start --arch x86_64 --mount /tmp/quorum_temp_data:w --runtime docker --cpu 2

# Sometimes we need to explicitly set the docker socket
export DOCKER_HOST="unix://$HOME/.colima/docker.sock"
docker info

# Build the fecfile tools
cd "$QUORUM_SITE/app/pac/fecfile"
docker-compose build
```