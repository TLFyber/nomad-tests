job "drainable-app" {
    region = "global"

    datacenters = ["dc1"]

    update {
        // Update 3 tasks at a time.
        max_parallel = 1

        // Wait 30 seconds between updates.
        stagger = "1s"
    }

    constraint {
      attribute = "${node.class}"
      value = "web"
      distinct_hosts = true
    }

    task "drainable-app" {
      driver = "docker"

      config {
          image = "drainable-app:latest"

          // See 'Using the Port Map' - https://www.nomadproject.io/docs/drivers/docker.html
          port_map {
            sinatra = 4567
          }
      }

      kill_timeout = "1s"

      resources {
          cpu = 500 # 500 MHz
          memory = 768 # 768MB
          network {
              mbits = 10
              port "sinatra" { static = 4567 }
          }
      }
    }
}
