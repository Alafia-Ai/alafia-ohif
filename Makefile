APP_NAME           := alafia-ohif
HOST_NAME          := ohif.alafia
HOST_IP            := 127.0.0.q
#DOCKER_PLATFORM    := linux/arm64
DOCKER_PLATFORM    := linux/amd64
DOCKER_IMAGE_NAME  := $(APP_NAME)
DOCKER_IMAGE_TAG   := latest
DOCKER_CONTEXT     := ./build
DOCKERFILE         := ./build/Dockerfile
DEPLOY_PATH        := ./deploy
SERVICE_FILE       := $(APP_NAME).service
DESKTOP_FILE       := $(APP_NAME).desktop
APPLICATIONS_DIR   := /usr/share/applications
MODIFYHOSTS_SCRIPT := ../modify-hosts.sh

# Build the Docker image
build:
	@echo "Building Docker image..."
	docker build --platform=$(DOCKER_PLATFORM) --no-cache -t $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) -f $(DOCKERFILE) $(DOCKER_CONTEXT)
	@echo "Docker image built successfully."

# Install the systemd service
install:
	@if [ -z "$(DESKTOP_FILE)" ]; then \
		echo "DESKTOP_FILE is not set. Skipping installation to APPLICATIONS_DIR."; \
	else \
		echo "Installing desktop entry..." && \
		sudo cp $(DEPLOY_PATH)/$(DESKTOP_FILE) $(APPLICATIONS_DIR) && \
		echo "Desktop entry installed successfully."; \
	fi
	

	@if [ -z "$(SERVICE_FILE)" ]; then \
		echo "SERVICE_FILE is not set. Skipping Systemd modification."; \
	else \
		echo "Installing systemd service..." && \
		sudo cp $(DEPLOY_PATH)/$(SERVICE_FILE) /etc/systemd/system/ && \
		sudo systemctl enable $(SERVICE_FILE) && \
		echo "Systemd service installed and started successfully."; \
	fi

	@if [ -z "$(HOST_NAME)" ]; then \
		echo "HOST_NAME is not set. Skipping hosts modification."; \
	else \
		echo "Adding entry to /etc/hosts..." && \
		sudo $(MODIFYHOSTS_SCRIPT) $(HOST_IP) $(HOST_NAME) add && \
		echo "Entry added to /etc/hosts successfully."; \
	fi

# Uninstall the systemd service and remove all installed files
uninstall:

	@if [ -z "$(DESKTOP_FILE)" ]; then \
		echo "DESKTOP_FILE is not set. Skipping removal from APPLICATIONS_DIR."; \
	else \
		echo "Removing desktop entry..." && \
		sudo rm -f $(APPLICATIONS_DIR)/$(DESKTOP_FILE) && \
		echo "Desktop entry removed successfully."; \
	fi
	
	@if [ -z "$(SERVICE_FILE)" ]; then \
		echo "SERVICE_FILE is not set. Skipping Systemd modification."; \
	else \
		echo "Stopping and disabling systemd service..." && \
		sudo systemctl stop $(SERVICE_FILE) && \
		sudo systemctl disable $(SERVICE_FILE) && \
		sudo rm -f /etc/systemd/system/$(SERVICE_FILE) && \
		echo "Systemd service stopped, disabled, and removed successfully."; \
	fi

	@if [ -z "$(HOST_NAME)" ]; then \
		echo "HOST_NAME is not set. Skipping hosts modification."; \
	else \
		echo "Removing entry from /etc/hosts..." && \
		sudo $(MODIFYHOSTS_SCRIPT) $(HOST_IP) $(HOST_NAME) remove && \
		echo "Entry removed from /etc/hosts successfully."; \
	fi

.PHONY: build install uninstall

