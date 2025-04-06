let
  pkgs = import <nixpkgs> {};
in pkgs.mkShell {
  buildInputs = [
    pkgs.docker
    pkgs.docker-compose
  ];

  packages = [ ];

  shellHook = ''
    echo "--- Nix Shell ---"
    # Check if Docker daemon is running
    if ! docker info > /dev/null 2>&1; then
      echo "Error: Docker daemon does not seem to be running."
      echo "Please start the Docker daemon and try again."
      # Optionally exit the shell if Docker isn't running
      # exit 1
    else
      echo "Docker daemon detected."
      # Check if docker-compose.yml exists
      if [ -f docker-compose.yml ]; then
        echo "Starting Docker Compose services in detached mode (background)..."
        # Start services defined in docker-compose.yml in detached mode (-d)
        # --remove-orphans cleans up any containers for services no longer defined
        docker-compose up -d --remove-orphans

        echo ""
        echo "Docker Compose services ('aider', etc.) are running in the background."
        echo "Run 'docker-compose ps' to see their status."
        echo "To interact with the 'aider' container:"
        echo "  - Attach to its TTY: docker attach $(docker-compose ps -q aider)"
        echo "  - Or run commands inside: docker exec -it $(docker-compose ps -q aider) <command> (e.g., bash)"
        echo ""
        echo "To stop the background services when you are finished, run:"
        echo "  docker-compose down"
        echo "--- End Nix Shell Setup ---"
      else
        echo "Warning: docker-compose.yml not found in the current directory."
        echo "         Docker Compose services were not started."
      fi
    fi

    # Unset the hook variable so it doesn't pollute the environment
    unset shellHook
  '';
}
