# Eric's Quorum Config

The docker setup here is mostly copied from the main repo but there are some
changes. First, this config tries to keep the containers lightweight. This means
only the system dependencies are built into containers, and the rest live on the
host filesystem.
