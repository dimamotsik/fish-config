function do
    set timeout 30
    set elapsed 0

    if not docker info > /dev/null 2>&1
        echo "Docker is not running. Starting Docker Desktop..."
        open -a Docker

        while not docker info > /dev/null 2>&1
            if test $elapsed -ge $timeout
                echo "Timeout: Docker did not start within $timeout seconds"
                return 1
            end

            sleep 1
            set elapsed (math $elapsed + 1)
        end

        echo "Docker is ready"
    else
        echo "Docker already running"
    end
end
